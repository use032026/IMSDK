import { chromium, expect } from '@playwright/test';
import { readFile, writeFile, mkdir, chmod, rename, copyFile, statfs } from 'node:fs/promises';
import { resolve, dirname } from 'node:path';
import { pathToFileURL } from 'node:url';
import { createHash, randomBytes, randomUUID } from 'node:crypto';

// Real UI writes only, two dedicated identities, no request interception or configuration injection.
// A stable private fixture and durable phase state make interrupted runs resumable without
// repeating registration, friend requests, group creation or messages already accepted by the server.
const root = resolve(dirname(new URL(import.meta.url).pathname), '../..');
const args = process.argv.slice(2);
const option = name => { const i = args.indexOf(name); return i < 0 ? undefined : args[i + 1]; };
const fixturePath = resolve(option('--fixture') ?? resolve(root, '.work/runtime-private/web-connected-20261028.json'));
const seedPath = option('--seed-config');
const evidence = resolve(option('--evidence') ?? resolve(root, 'logs/web-connected-20261028'));
const work = resolve(option('--work') ?? resolve(root, '.codex-build/web-connected-20261028/live-entry'));
const entrySource = resolve(option('--entry') ?? resolve(root, 'web/handoff/examples/plain-html/index.html'));
const configSource = resolve(dirname(entrySource), 'host-config.js');
const bundleSource = resolve(option('--bundle') ?? resolve(root, 'web/dist/im-sdk.js'));
const resumeGroupOnly = args.includes('--resume-group-only');
const hash = value => createHash('sha256').update(value).digest('hex');
class Stop extends Error { constructor(code) { super(code); this.code = code; } }
const ensure = (value, code) => { if (!value) throw new Stop(code); };
ensure(fixturePath.startsWith(resolve(root, '.work/runtime-private') + '/'), 'PRIVATE_FIXTURE_PATH_REQUIRED');
ensure(work.startsWith(resolve(root, '.codex-build/web-connected-20261028') + '/'), 'DEDICATED_WORK_PATH_REQUIRED');
await mkdir(dirname(fixturePath), { recursive: true, mode: 0o700 });
await mkdir(evidence, { recursive: true });
async function privateWrite(path, value) {
  const temporary = `${path}.${randomUUID()}.tmp`;
  await writeFile(temporary, JSON.stringify(value, null, 2) + '\n', { mode: 0o600 });
  await chmod(temporary, 0o600);
  await rename(temporary, path);
}
let fixture;
try { fixture = JSON.parse(await readFile(fixturePath, 'utf8')); }
catch (error) {
  if (error.code !== 'ENOENT') throw error;
  ensure(seedPath, 'SEED_CONFIG_REQUIRED_FOR_FIRST_RUN');
  const seed = JSON.parse(await readFile(resolve(seedPath), 'utf8'));
  ensure(seed.configuration?.apiBaseUrl && seed.configuration?.serviceRealmId, 'SEED_CONFIGURATION_MISSING');
  const suffix = randomBytes(5).toString('hex');
  const runId = `20261028-${suffix}`;
  fixture = { runId, createdAt: new Date().toISOString(), configuration: seed.configuration,
    accounts: Object.fromEntries(['a', 'b'].map(side => [side, {
      channel: 'email', identifier: `imsdk.connected.${suffix}.${side}@qa.invalid`,
      displayName: `SDK QA Connected ${side.toUpperCase()} ${suffix}`,
      password: `Qa!${randomBytes(24).toString('base64url')}a7`,
    }])) };
  await privateWrite(fixturePath, fixture);
}
await chmod(fixturePath, 0o600);
ensure(/^[a-zA-Z0-9_-]{1,60}$/.test(fixture.runId ?? ''), 'INVALID_RUN_ID');
const runId = fixture.runId;
const privateRoot = resolve(dirname(fixturePath), `web-connected-${runId}`);
await mkdir(privateRoot, { recursive: true, mode: 0o700 });
await chmod(privateRoot, 0o700);
const statePath = resolve(privateRoot, 'state.json');
let state;
try { state = JSON.parse(await readFile(statePath, 'utf8')); }
catch (error) { if (error.code !== 'ENOENT') throw error; }
state ??= { runId, accounts: { a: {}, b: {} }, friend: {}, direct: {}, group: {}, attempts: [], rawCounter: 0 };
ensure(state.runId === runId, 'PHASE_FIXTURE_MISMATCH');
const attemptId = new Date().toISOString().replace(/[^0-9]/g, '');
const report = { runId, attemptId, startedAt: new Date().toISOString(), passed: false,
  realBackend: true, actualDefaultEntry: true, entryProtocol: 'file:',
  apiResponseInterception: false, serviceConfigurationInjected: false, securityBypass: false,
  browser: 'Google Chrome, two isolated browser contexts',
  verificationMessagesSent: 0, registrationsThisAttempt: 0, messagesSentThisAttempt: 0,
  resumedExistingDedicatedPair: state.attempts.length > 0, stages: [], requests: [], errors: [],
  currentRunMarkersOnly: true,
  workflowMode: resumeGroupOnly ? 'resume-missing-group-after-local-infrastructure-interruption' : 'full-new-pair-workflow',
  source: {}, checks: {}, outputRoot: 'logs/web-connected-20261028' };
state.attempts.push({ attemptId, startedAt: report.startedAt });
let writeChain = Promise.resolve();
const saveState = () => {
  const snapshot = JSON.parse(JSON.stringify(state));
  // A transient disk/write failure must not poison every later checkpoint retry.
  writeChain = writeChain.catch(() => {}).then(() => privateWrite(statePath, snapshot));
  return writeChain;
};
const record = (stage, details = {}) => {
  const item = { stage, at: new Date().toISOString(), ...details };
  report.stages.push(item);
  console.log(JSON.stringify(item));
};
const safeCode = error => error instanceof Stop ? error.code : error?.code === 'ENOSPC' ? 'LOCAL_DISK_FULL' : 'CONNECTED_VALIDATION_FAILED';
const sanitizedPath = path => path.replace(/[0-9a-f]{8}-[0-9a-f-]{27,}/gi, ':id');
const rows = value => Array.isArray(value) ? value : value?.items ?? [];
const text = row => { try { return (typeof row.body === 'string' ? JSON.parse(row.body) : row.body)?.text; } catch { return undefined; } };
const seq = row => Number(row.conversationSeq ?? row.seq ?? 0);
const peerOf = side => side === 'a' ? 'b' : 'a';
const marker = (kind, side) => `IMSDK-${runId}-${kind}-${side.toUpperCase()}`;
const groupTitle = `IMSDK-${runId}-Connected`;
const pages = {}, contexts = {}, pendingCaptures = new Set();
let browser;
const api = String(fixture.configuration.apiBaseUrl).replace(/\/+$/, '');
const apiOrigin = new URL(api).origin;
async function rawEvidence(label, value) {
  const number = ++state.rawCounter;
  await privateWrite(resolve(privateRoot, `${String(number).padStart(5, '0')}-${label}.json`), value);
}
async function drainCaptures() {
  while (pendingCaptures.size) await Promise.all([...pendingCaptures]);
  await writeChain;
}
function observe(page, side) {
  page.on('pageerror', error => {
    report.errors.push(`${side.toUpperCase()}_UNHANDLED_BROWSER_ERROR`);
    const task = rawEvidence(`${side}-page-error`, { name: error.name, message: error.message, stack: error.stack });
    pendingCaptures.add(task); task.then(() => pendingCaptures.delete(task), () => pendingCaptures.delete(task));
  });
  page.on('response', response => {
    const url = new URL(response.url());
    if (url.origin !== apiOrigin || !url.pathname.startsWith('/api/')) return;
    const task = (async () => {
      let envelope;
      try { envelope = await response.json(); } catch { envelope = { nonJsonResponse: true }; }
      const method = response.request().method();
      let submitted;
      try { submitted = JSON.parse(response.request().postData() ?? '{}'); } catch { submitted = {}; }
      if (url.pathname.endsWith('/verification/send') && method === 'POST') report.verificationMessagesSent++;
      report.requests.push({ side, path: sanitizedPath(url.pathname), method, status: response.status(),
        code: /^[A-Z0-9_.]{1,80}$/.test(envelope.code ?? '') ? envelope.code : undefined,
        allowOrigin: response.headers()['access-control-allow-origin'] ?? null });
      await rawEvidence(`${side}-browser-response`, { url: response.url(), method, requestBody: response.request().postData(), status: response.status(), envelope });
      if (url.pathname.endsWith('/verification/settings') && envelope.code === 'OK') state.accounts[side].settings = envelope.data;
      if (url.pathname.endsWith('/auth/register') && method === 'POST') {
        state.accounts[side].registrationResponseCode = envelope.code;
        if (response.ok() && envelope.code === 'OK') {
          state.accounts[side].registered = true;
          state.accounts[side].pendingApproval = envelope.data?.pendingApproval === true;
          state.accounts[side].registrationSourceBundleSha256 = report.source.bundleSha256;
        }
      }
      if (url.pathname.endsWith('/search/users') && envelope.code === 'OK') state.accounts[side].lastSearch = envelope.data;
      if (url.pathname.endsWith('/friends/request') && method === 'POST' && envelope.code === 'OK') {
        ensure(side === 'a' && submitted.toUserId === state.accounts.b.user?.userId, 'UI_FRIEND_REQUEST_SCOPE_MISMATCH');
        state.friend.submission = envelope.data;
        state.friend.requestSentThroughUi = true;
      }
      if (/\/friends\/requests\/[^/]+\/handle$/.test(url.pathname) && method === 'POST' && envelope.code === 'OK') state.friend.acceptedThroughUi = true;
      if (url.pathname.endsWith('/direct-chats') && method === 'POST' && envelope.code === 'OK') {
        ensure(side === 'a' && submitted.peerUserId === state.accounts.b.user?.userId, 'UI_DIRECT_SCOPE_MISMATCH');
        state.direct.conversationId = envelope.data?.conversationId ?? envelope.data?.chatId;
        state.direct.createdThroughUi = true;
      }
      if (/\/groups\/?$/.test(url.pathname) && method === 'POST' && envelope.code === 'OK') {
        ensure(side === 'a' && submitted.title === groupTitle && submitted.memberUserIds?.length === 1 && submitted.memberUserIds[0] === state.accounts.b.user?.userId, 'UI_GROUP_SCOPE_MISMATCH');
        state.group.conversationId = envelope.data?.groupId;
        state.group.createdThroughUi = true;
      }
      if (/\/(direct-chats|groups)\/[^/]+\/messages$/.test(url.pathname) && method === 'POST' && envelope.code === 'OK') {
        const kind = url.pathname.includes('/groups/') ? 'group' : 'direct';
        ensure(submitted.body?.text === marker(kind, side), 'UI_MESSAGE_MARKER_SCOPE_MISMATCH');
        state[kind][`${side}SentThroughUi`] = true;
        report.messagesSentThisAttempt++;
      }
      await saveState();
    })().catch(async error => {
      report.errors.push('PRIVATE_RESPONSE_CAPTURE_FAILED');
      await rawEvidence('capture-error', { message: String(error?.message ?? error) }).catch(() => {});
    });
    pendingCaptures.add(task); task.then(() => pendingCaptures.delete(task), () => pendingCaptures.delete(task));
  });
}
async function snapshot(side, name) {
  const page = pages[side];
  const raw = resolve(privateRoot, `${attemptId}-${side}-${name}.png`);
  await page.screenshot({ path: raw, fullPage: true });
  await chmod(raw, 0o600);
  const masks = [page.locator('input'), page.locator('.meta'), page.locator('.preview')];
  for (const account of Object.values(fixture.accounts)) masks.push(page.getByText(account.identifier, { exact: true }));
  await page.screenshot({ path: resolve(evidence, `${attemptId}-${side}-${name}.png`), fullPage: true, mask: masks });
}
async function identity(side) {
  const user = await pages[side].evaluate(() => window.IMSDK_HOST.client.currentUser);
  ensure(user?.userId && user?.platformUserId && user?.spaceId, `${side.toUpperCase()}_IDENTITY_UNRESOLVED`);
  const previous = state.accounts[side].user;
  if (previous) ensure(['userId', 'platformUserId', 'spaceId'].every(key => previous[key] === user[key]), 'RELOGIN_IDENTITY_CHANGED');
  state.accounts[side].user = user;
  await saveState();
  return user;
}
function solveCaptcha(question) {
  const match = String(question).match(/(-?\d+)\s*([+\-*×/÷])\s*(-?\d+)/);
  ensure(match, 'MANUAL_CAPTCHA_REQUIRED');
  const a = Number(match[1]), b = Number(match[3]);
  const value = match[2] === '+' ? a + b : match[2] === '-' ? a - b : ['*', '×'].includes(match[2]) ? a * b : a / b;
  ensure(Number.isFinite(value) && Number.isInteger(value), 'MANUAL_CAPTCHA_REQUIRED');
  return String(value);
}
async function submitAuthentication(side, kind) {
  const page = pages[side], account = fixture.accounts[side];
  for (let attempt = 0; attempt < 3; attempt++) {
    const previous = await page.evaluate(() => window.__connectedEvents.filter(event => event.type === 'authenticationFailed').length);
    if (kind === 'login') await page.getByPlaceholder('密码', { exact: true }).fill(account.password);
    if (kind === 'register') { state.accounts[side].registrationSubmitted = true; await saveState(); }
    await page.getByRole('button', { name: kind === 'register' ? '注册并登录' : '登录', exact: true }).click();
    await expect.poll(() => page.evaluate(count => window.IMSDK_HOST.client.isAuthenticated || window.__connectedEvents.filter(event => event.type === 'authenticationFailed').length > count, previous), { timeout: 45000 }).toBe(true);
    if (await page.evaluate(() => window.IMSDK_HOST.client.isAuthenticated)) return;
    await drainCaptures();
    const code = await page.evaluate(() => window.__connectedEvents.filter(event => event.type === 'authenticationFailed').at(-1)?.code);
    if (!/CAPTCHA/.test(code ?? '')) throw new Stop(code ?? 'AUTHENTICATION_INCOMPLETE');
    // Use the normal, server-issued challenge and its UI answer field; never bypass it.
    const question = page.locator('.captcha-question');
    await expect(question).not.toBeEmpty({ timeout: 15000 });
    await page.getByPlaceholder('安全验证答案', { exact: true }).fill(solveCaptcha(await question.textContent()));
    record('normalCaptchaAnswered', { side, kind });
  }
  throw new Stop('CAPTCHA_RETRY_LIMIT');
}
async function logoutUi(side) {
  await returnToList(side);
  await pages[side].getByRole('button', { name: '退出登录', exact: true }).click();
  await pages[side].getByRole('button', { name: '注册新账号', exact: true }).waitFor();
  ensure(await pages[side].evaluate(() => !window.IMSDK_HOST.client.isAuthenticated && window.IMSDK_HOST.client.currentUser === undefined), 'LOGOUT_RETAINED_SESSION');
}
async function loginUi(side) {
  const page = pages[side], account = fixture.accounts[side];
  await page.getByPlaceholder('账号', { exact: true }).fill(account.identifier);
  await submitAuthentication(side, 'login');
  await page.getByRole('button', { name: '发起单聊', exact: true }).waitFor({ timeout: 30000 });
  await identity(side);
  state.accounts[side].passwordRelogin = true;
  await saveState();
  record('passwordReloginThroughDefaultUi', { side, actualSpaceKind: state.accounts[side].user.spaceId === 'personal' ? 'personal' : 'enterprise' });
}
async function registerAndRelogin(side, entryUrl) {
  const page = pages[side], account = fixture.accounts[side], current = state.accounts[side];
  await page.goto(entryUrl);
  await page.getByRole('button', { name: '注册新账号', exact: true }).waitFor({ timeout: 20000 });
  const config = await page.evaluate(() => window.IMSDK_HOST.client.config);
  ensure(config?.apiBaseUrl?.replace(/\/+$/, '') === api && config.serviceRealmId === fixture.configuration.serviceRealmId, 'DEFAULT_HOST_CONFIGURATION_MISMATCH');
  ensure(config.privacyConsentGranted === true, 'HOST_CONSENT_NOT_GRANTED');
  await page.evaluate(() => {
    window.__connectedEvents = [];
    window.__connectedUnsubscribe = window.IMSDK_HOST.client.on(event => window.__connectedEvents.push({ type: event.type, code: event.code }));
  });
  ensure(await page.locator('#configuration').count() === 0, 'TECHNICAL_CONFIGURATION_FORM_VISIBLE');
  record('fileDefaultEntryReady', { side, defaultConfigurationLoadedWithoutInjection: true });
  if (!current.registered && !current.registrationSubmitted) {
    await page.getByRole('button', { name: '注册新账号', exact: true }).click();
    await page.getByLabel('注册方式', { exact: true }).selectOption(account.channel);
    await drainCaptures();
    const settings = state.accounts[side].settings;
    ensure(settings?.emailEnabled === true && settings.emailRequired === false, 'REGISTRATION_VERIFICATION_DELIVERY_REQUIRED');
    ensure(await page.locator('select').count() === 1, 'UNEXPECTED_REGISTRATION_SPACE_SELECTOR');
    await page.getByPlaceholder('昵称', { exact: true }).fill(account.displayName);
    await page.getByPlaceholder('邮箱', { exact: true }).fill(account.identifier);
    await page.getByPlaceholder('设置密码', { exact: true }).fill(account.password);
    await page.getByPlaceholder('确认密码', { exact: true }).fill(account.password);
    await snapshot(side, 'registration-form');
    await submitAuthentication(side, 'register');
    await page.getByRole('button', { name: '发起单聊', exact: true }).waitFor({ timeout: 30000 });
    await drainCaptures();
    ensure(state.accounts[side].registered && !state.accounts[side].pendingApproval, 'REGISTRATION_NOT_CONFIRMED');
    await identity(side);
    state.accounts[side].automaticRegistrationEntry = true;
    state.accounts[side].registeredAt = new Date().toISOString();
    report.registrationsThisAttempt++;
    await saveState();
    record('newRegistrationAutomaticEntry', { side, noSpaceChooser: true, verificationCodeSent: false, oneActiveSpace: true });
    await snapshot(side, 'registration-entered-conversations');
    await logoutUi(side);
    // A document reload creates a fresh SDK client and proves password login independently.
    await page.reload();
    await page.getByRole('button', { name: '注册新账号', exact: true }).waitFor();
    await page.evaluate(() => {
      window.__connectedEvents = [];
      window.__connectedUnsubscribe = window.IMSDK_HOST.client.on(event => window.__connectedEvents.push({ type: event.type, code: event.code }));
    });
  } else {
    ensure(!current.pendingApproval, 'REGISTER_PENDING_APPROVAL');
    record('dedicatedAccountResumeWithoutRegistration', { side, registrationSubmittedPreviously: true, automaticEntryPreviouslyVerified: current.automaticRegistrationEntry === true });
  }
  await loginUi(side);
  await snapshot(side, 'password-relogin');
}
async function acceptedToken(side) {
  return pages[side].evaluate(() => window.IMSDK_HOST.client.credentials?.accessToken);
}
async function readAs(side, path) {
  const token = await acceptedToken(side);
  ensure(token, 'ACCEPTED_UI_BEARER_UNAVAILABLE');
  let response, envelope;
  for (let attempt = 0; attempt < 3; attempt++) {
    try {
      response = await fetch(api + path, { headers: { Authorization: `Bearer ${token}`, Accept: 'application/json' },
        credentials: 'omit', redirect: 'error', signal: AbortSignal.timeout(20000) });
      envelope = await response.json();
      break;
    } catch { if (attempt === 2) throw new Stop('INDEPENDENT_READ_TRANSPORT_FAILED'); }
  }
  await rawEvidence(`${side}-independent-read`, { path, status: response.status, envelope });
  report.requests.push({ side: `${side}-independent-peer-read`, path: sanitizedPath(path.split('?')[0]), method: 'GET', status: response.status });
  ensure(response.ok && envelope.code === 'OK', `INDEPENDENT_READ_HTTP_${response.status}`);
  return envelope.data;
}
async function returnToList(side) {
  const page = pages[side];
  if (await page.getByRole('button', { name: '发起单聊', exact: true }).isVisible().catch(() => false)) return;
  await page.getByRole('button', { name: '返回', exact: true }).click();
  await page.getByRole('button', { name: '发起单聊', exact: true }).waitFor();
}
async function verifyProfiles() {
  for (const side of ['a', 'b']) {
    const profile = await readAs(side, '/api/client/v1/profile/me');
    let claims;
    try { claims = JSON.parse(Buffer.from((await acceptedToken(side)).split('.')[1], 'base64url').toString('utf8')); } catch { claims = {}; }
    const subject = claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
    const platformId = profile.platformUserId || (subject === profile.userId ? claims.platform_user_id : undefined);
    ensure(profile.userId === state.accounts[side].user.userId && platformId === state.accounts[side].user.platformUserId, 'INDEPENDENT_PROFILE_IDENTITY_MISMATCH');
  }
  ensure(state.accounts.a.user.userId !== state.accounts.b.user.userId && state.accounts.a.user.spaceId === state.accounts.b.user.spaceId, 'DEDICATED_PAIR_SPACE_MISMATCH');
  record('independentHttpIdentitiesVerified', { distinctDedicatedUsers: true, acceptedUiBearerBoundToProfile: true });
}
async function contactRows(side) { return rows(await readAs(side, '/api/client/v1/friends')); }
const contactId = row => row.friendUserId ?? row.userId;
async function friendship() {
  const a = state.accounts.a.user.userId, b = state.accounts.b.user.userId;
  const existing = (await contactRows('a')).some(row => contactId(row) === b);
  if (!existing) {
    const incoming = rows(await readAs('b', '/api/client/v1/friends/requests')).filter(row => row.fromUserId === a && row.toUserId === b);
    ensure(incoming.length <= 1, 'DEDICATED_FRIEND_REQUEST_DUPLICATED');
    if (!incoming.length) {
      ensure(!state.friend.requestIntent, 'FRIEND_SUBMISSION_UNCERTAIN_NOT_REPEATED');
      const page = pages.a;
      await page.getByRole('button', { name: '添加好友', exact: true }).click();
      await page.getByPlaceholder('搜索账号、手机号或邮箱', { exact: true }).fill(fixture.accounts.b.identifier);
      await page.getByPlaceholder('好友申请消息（可选）', { exact: true }).fill(marker('friend', 'a'));
      await page.getByRole('button', { name: '搜索用户', exact: true }).click();
      const result = page.locator('div.row').filter({ hasText: fixture.accounts.b.displayName });
      await result.getByRole('button', { name: '添加好友', exact: true }).waitFor();
      await drainCaptures();
      ensure(state.accounts.a.lastSearch?.length === 1 && state.accounts.a.lastSearch[0].userId === b, 'FRIEND_UI_SEARCH_IDENTITY_MISMATCH');
      state.friend.requestIntent = true; await saveState();
      await result.getByRole('button', { name: '添加好友', exact: true }).click();
      await page.getByRole('button', { name: '已申请', exact: true }).waitFor({ timeout: 30000 });
      await drainCaptures();
      ensure(state.friend.submission?.requestId && state.friend.submission.status === 'pending', 'FRIEND_REQUEST_NOT_PENDING');
      state.friend.requestSentThroughUi = true; await saveState();
      record('friendSearchAndRequestThroughUi', { exactDedicatedPeer: true, pendingAcceptance: true });
      await snapshot('a', 'friend-request-sent');
    }
    await returnToList('b');
    await pages.b.getByRole('button', { name: '好友申请', exact: true }).click();
    const request = pages.b.locator('div.row').filter({ hasText: fixture.accounts.a.displayName }).filter({ hasText: marker('friend', 'a') });
    await request.getByRole('button', { name: '同意', exact: true }).waitFor({ timeout: 30000 });
    await snapshot('b', 'friend-request-received');
    await request.getByRole('button', { name: '同意', exact: true }).click();
    await request.getByText('已成为好友', { exact: true }).waitFor({ timeout: 30000 });
    await drainCaptures();
    ensure(state.friend.acceptedThroughUi, 'FRIEND_ACCEPTANCE_UI_RESPONSE_MISSING');
    record('friendRequestAcceptedThroughPeerUi');
  }
  for (const side of ['a', 'b']) {
    const peer = peerOf(side), id = state.accounts[peer].user.userId;
    ensure((await contactRows(side)).filter(row => contactId(row) === id).length === 1, 'FRIEND_CONTACT_READBACK_MISMATCH');
    await returnToList(side);
    await pages[side].getByRole('button', { name: '发起单聊', exact: true }).click();
    await pages[side].getByRole('button', { name: `与${fixture.accounts[peer].displayName}聊天`, exact: true }).waitFor({ timeout: 30000 });
    await snapshot(side, 'friend-visible-in-contacts');
    await returnToList(side);
  }
  state.friend.bothContactsVisible = true; await saveState();
  record('bothFriendContactListsVerified', { uiVisibleBothSides: true, independentHttpReadback: true });
}
async function conversations(side) { return rows(await readAs(side, '/api/client/v1/conversations?limit=100')); }
async function findConversation(side, kind) {
  let found;
  await expect.poll(async () => {
    const matches = (await conversations(side)).filter(row => kind === 'direct'
      ? row.conversationType === 'direct' && row.peerUserId === state.accounts[peerOf(side)].user.userId
      : row.conversationType === 'group' && row.title === groupTitle);
    ensure(matches.length <= 1, 'TASK_CONVERSATION_DUPLICATED');
    found = matches[0]; return !!found;
  }, { timeout: 45000, intervals: [1000, 2000, 3000] }).toBe(true);
  return found;
}
async function openConversationUi(side, kind) {
  await returnToList(side);
  const conversation = await findConversation(side, kind);
  await pages[side].getByRole('button', { name: '刷新', exact: true }).click();
  const row = pages[side].getByRole('button', { name: new RegExp('^' + conversation.title.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '，') });
  await row.click({ timeout: 30000 });
  await pages[side].getByRole('textbox', { name: '消息内容', exact: true }).waitFor({ timeout: 30000 });
  return conversation;
}
const endpoint = (kind, id) => `/api/client/v1/${kind === 'direct' ? 'direct-chats' : 'groups'}/${encodeURIComponent(id)}/messages?limit=100`;
async function sendUiMessage(side, kind, id) {
  const peer = peerOf(side), message = marker(kind, side);
  const existing = rows(await readAs(peer, endpoint(kind, id))).filter(row => row.senderUserId === state.accounts[side].user.userId && text(row) === message);
  ensure(existing.length <= 1, 'TASK_MESSAGE_DUPLICATED');
  if (!existing.length) {
    state[kind][`${side}MessageIntent`] = true; await saveState();
    await pages[side].getByRole('textbox', { name: '消息内容', exact: true }).fill(message);
    await pages[side].getByRole('button', { name: '发送', exact: true }).click();
    await expect(pages[side].getByRole('textbox', { name: '消息内容', exact: true })).toHaveValue('', { timeout: 30000 });
    state[kind][`${side}SentThroughUi`] = true;
    await saveState();
    record('newMessageSentThroughUi', { side, kind });
  } else record('priorAttemptMessagePreservedWithoutDuplicateSend', { side, kind, newMessageThisAttempt: false });
  await pages[side].getByText(message, { exact: true }).waitFor({ timeout: 30000 });
}
async function verifyRoundTrip(kind, id) {
  const output = {};
  for (const reader of ['a', 'b']) {
    const all = rows(await readAs(reader, endpoint(kind, id)));
    const matched = ['a', 'b'].map(side => all.filter(row => row.senderUserId === state.accounts[side].user.userId && text(row) === marker(kind, side)));
    ensure(matched.every(items => items.length === 1) && seq(matched[0][0]) > 0 && seq(matched[1][0]) > seq(matched[0][0]), 'PERSISTED_MESSAGE_SENDER_SEQUENCE_OR_CONTENT_MISMATCH');
    output[reader] = { outgoingSequence: seq(matched[0][0]), replySequence: seq(matched[1][0]) };
    await pages[reader].getByRole('button', { name: '刷新', exact: true }).click();
    await pages[reader].getByText(marker(kind, 'a'), { exact: true }).waitFor({ timeout: 30000 });
    await pages[reader].getByText(marker(kind, 'b'), { exact: true }).waitFor({ timeout: 30000 });
    await snapshot(reader, `${kind}-bidirectional-history`);
  }
  state[kind].roundTripVerified = true; state[kind].readback = output; await saveState();
  record('bidirectionalUiAndIndependentPersistenceVerified', { kind, exactSenders: true, exactContentOnceEach: true, sequenceIncreasing: true, bothIndependentIdentityReads: true, sequences: output });
}
async function directFlow() {
  const existing = (await conversations('a')).filter(row => row.conversationType === 'direct' && row.peerUserId === state.accounts.b.user.userId);
  ensure(existing.length <= 1, 'DIRECT_CONVERSATION_DUPLICATED');
  if (!existing.length) {
    await returnToList('a');
    await pages.a.getByRole('button', { name: '发起单聊', exact: true }).click();
    await pages.a.getByRole('button', { name: `与${fixture.accounts.b.displayName}聊天`, exact: true }).click();
    await pages.a.getByRole('textbox', { name: '消息内容', exact: true }).waitFor({ timeout: 30000 });
    state.direct.createdThroughUi = true; await saveState();
    record('newDirectConversationOpenedThroughUi');
  } else await openConversationUi('a', 'direct');
  await drainCaptures();
  const conversation = state.direct.conversationId ? { conversationId: state.direct.conversationId } : await findConversation('a', 'direct');
  state.direct.conversationId = conversation.conversationId; await saveState();
  await sendUiMessage('a', 'direct', conversation.conversationId);
  await openConversationUi('b', 'direct');
  await pages.b.getByText(marker('direct', 'a'), { exact: true }).waitFor({ timeout: 30000 });
  await sendUiMessage('b', 'direct', conversation.conversationId);
  await verifyRoundTrip('direct', conversation.conversationId);
}
async function verifyGroupScope(id) {
  for (const side of ['a', 'b']) {
    const detail = await readAs(side, `/api/client/v1/groups/${encodeURIComponent(id)}`);
    const members = rows(await readAs(side, `/api/client/v1/groups/${encodeURIComponent(id)}/members`));
    const ids = members.map(row => row.userId ?? row.memberUserId ?? row.targetUserId ?? row.id ?? row.user?.userId);
    ensure(detail.ownerUserId === state.accounts.a.user.userId && ids.length === 2 && new Set(ids).size === 2 && ['a', 'b'].every(role => ids.includes(state.accounts[role].user.userId)), 'EXACT_DEDICATED_GROUP_SCOPE_MISMATCH');
  }
  record('newGroupOwnerAndExactTwoMembersVerified', { ownerIsA: true, exactMembersAB: true, independentlyReadByBothIdentities: true });
}
async function groupFlow() {
  const existing = (await conversations('a')).filter(row => row.conversationType === 'group' && row.title === groupTitle);
  ensure(existing.length <= 1, 'TASK_GROUP_DUPLICATED');
  if (!existing.length) {
    ensure(!state.group.createIntent, 'GROUP_CREATION_UNCERTAIN_NOT_REPEATED');
    await returnToList('a');
    await pages.a.getByRole('button', { name: '发起单聊', exact: true }).click();
    await pages.a.getByRole('button', { name: '新建群聊', exact: true }).click();
    await pages.a.getByPlaceholder('群名称', { exact: true }).fill(groupTitle);
    await pages.a.getByRole('checkbox', { name: `邀请${fixture.accounts.b.displayName}`, exact: true }).check();
    ensure(await pages.a.getByRole('checkbox', { checked: true }).count() === 1, 'GROUP_UI_SELECTION_NOT_EXACTLY_PEER');
    await snapshot('a', 'group-create-with-peer');
    state.group.createIntent = true; await saveState();
    await pages.a.getByRole('button', { name: '创建群聊', exact: true }).click();
    await pages.a.getByRole('textbox', { name: '消息内容', exact: true }).waitFor({ timeout: 30000 });
    state.group.createdThroughUi = true; await saveState();
    record('newTwoMemberGroupCreatedThroughUi');
  } else await openConversationUi('a', 'group');
  await drainCaptures();
  const group = state.group.conversationId ? { conversationId: state.group.conversationId } : await findConversation('a', 'group');
  state.group.conversationId = group.conversationId; await saveState();
  await verifyGroupScope(group.conversationId);
  await sendUiMessage('a', 'group', group.conversationId);
  await openConversationUi('b', 'group');
  await pages.b.getByText(marker('group', 'a'), { exact: true }).waitFor({ timeout: 30000 });
  await sendUiMessage('b', 'group', group.conversationId);
  await verifyRoundTrip('group', group.conversationId);
}

try {
  const disk = await statfs(root);
  ensure(disk.bavail * disk.bsize >= 256 * 1024 ** 2, 'LOCAL_DISK_SPACE_TOO_LOW_FOR_BROWSER_RUN');
  const sourceBytes = { entry: await readFile(entrySource), hostConfig: await readFile(configSource), bundle: await readFile(bundleSource) };
  const destination = { entry: resolve(work, 'examples/plain-html/index.html'), hostConfig: resolve(work, 'examples/plain-html/host-config.js'), bundle: resolve(work, 'sdk/im-sdk.js') };
  await mkdir(dirname(destination.entry), { recursive: true }); await mkdir(dirname(destination.bundle), { recursive: true });
  for (const [name, source] of Object.entries({ entry: entrySource, hostConfig: configSource, bundle: bundleSource })) {
    await copyFile(source, destination[name]); ensure(hash(await readFile(destination[name])) === hash(sourceBytes[name]), 'STAGED_ENTRY_BYTES_DIFFER');
    report.source[`${name}Sha256`] = hash(sourceBytes[name]);
  }
  report.source.scriptSha256 = hash(await readFile(new URL(import.meta.url)));
  report.source.sdkPackageVersion = JSON.parse(await readFile(resolve(root, 'web/package.json'), 'utf8')).version;
  report.source.entryPath = entrySource.startsWith(root + '/') ? entrySource.slice(root.length + 1) : entrySource;
  report.source.stagedExactCopy = true;
  report.source.apiOriginSha256 = hash(apiOrigin);
  try {
    const prior = await readFile(resolve(evidence, 'first-attempt-interruption.json'));
    report.priorAttemptEvidence = { path: 'logs/web-connected-20261028/first-attempt-interruption.json', sha256: hash(prior),
      purpose: 'Actual new registrations, friendship, direct messages and group creation completed before local disk interruption; this continuation never claims them as new writes in this attempt.' };
  } catch (error) { if (error.code !== 'ENOENT') throw error; }
  const entryUrl = pathToFileURL(destination.entry).href;
  browser = await chromium.launch({ channel: 'chrome', headless: true, args: [
    '--disk-cache-size=1048576', '--media-cache-size=1048576', '--disable-gpu-shader-disk-cache',
  ] });
  for (const side of ['a', 'b']) {
    contexts[side] = await browser.newContext({ viewport: { width: 430, height: 900 } });
    pages[side] = await contexts[side].newPage(); observe(pages[side], side);
    await registerAndRelogin(side, entryUrl);
  }
  await verifyProfiles();
  if (resumeGroupOnly) {
    ensure(report.priorAttemptEvidence && ['a', 'b'].every(side => state.accounts[side].registered && state.accounts[side].automaticRegistrationEntry && state.accounts[side].passwordRelogin)
      && state.friend.requestSentThroughUi && state.friend.acceptedThroughUi && state.friend.bothContactsVisible
      && state.direct.createdThroughUi && state.direct.roundTripVerified && state.direct.aSentThroughUi && state.direct.bSentThroughUi
      && state.group.createdThroughUi && state.group.conversationId, 'DURABLE_FIRST_ATTEMPT_PROOFS_REQUIRED');
    record('priorCurrentRunProofsPreserved', { newlyRegisteredPairAndFriendshipAndDirect: true, firstAttemptEvidenceLinked: true, noRepeatedBusinessWrites: true });
  } else {
    await friendship();
    await directFlow();
  }
  await groupFlow();
  for (const side of ['a', 'b']) {
    await returnToList(side);
    await pages[side].getByRole('button', { name: '刷新', exact: true }).click();
    await findConversation(side, 'direct'); await findConversation(side, 'group');
    await snapshot(side, 'final-conversation-list');
    await logoutUi(side);
    await pages[side].evaluate(async () => { window.__connectedUnsubscribe?.(); await window.IMSDK_HOST.client.shutdown(); });
    ensure(await pages[side].evaluate(() => !window.IMSDK_HOST.client.isInitialized && !window.IMSDK_HOST.client.isAuthenticated && window.IMSDK_HOST.client.currentUser === undefined), 'FINAL_SHUTDOWN_RETAINED_STATE');
    state.accounts[side].logoutAndShutdown = true; await saveState();
    record('logoutAndShutdownVerified', { side, activeSessions: 0 });
  }
  await drainCaptures();
  report.checks = {
    newDedicatedRegistrationsAutomaticEntry: ['a', 'b'].every(side => state.accounts[side].registered && state.accounts[side].automaticRegistrationEntry),
    freshDocumentPasswordRelogin: ['a', 'b'].every(side => state.accounts[side].passwordRelogin),
    registrationSourceBundleMatchesCurrent: ['a', 'b'].every(side => state.accounts[side].registrationSourceBundleSha256 === report.source.bundleSha256),
    friendRequestAndAcceptanceThroughUi: state.friend.requestSentThroughUi === true && state.friend.acceptedThroughUi === true,
    contactsVisibleBothSides: state.friend.bothContactsVisible === true,
    newDirectCreatedThroughUi: state.direct.createdThroughUi === true,
    directBidirectionalUiAndPersistence: state.direct.roundTripVerified === true && state.direct.aSentThroughUi === true && state.direct.bSentThroughUi === true,
    newGroupCreatedThroughUiWithExactAB: state.group.createdThroughUi === true,
    groupBidirectionalUiAndPersistence: state.group.roundTripVerified === true && state.group.aSentThroughUi === true && state.group.bSentThroughUi === true,
    bothLogoutAndShutdown: ['a', 'b'].every(side => state.accounts[side].logoutAndShutdown),
    noVerificationMessagesSent: report.verificationMessagesSent === 0,
    noUnhandledBrowserErrors: report.errors.length === 0,
  };
  ensure(Object.values(report.checks).every(Boolean), 'REQUIRED_CONNECTED_CHECKPOINT_MISSING');
  report.passed = true;
  state.completed = true;
} catch (error) {
  const code = safeCode(error);
  report.errors.push(code);
  record('validationStopped', { code });
  await rawEvidence('failure', { name: error?.name, code, message: String(error?.message ?? error), stack: error?.stack }).catch(() => {});
  for (const side of Object.keys(pages)) await snapshot(side, 'failure').catch(() => {});
  process.exitCode = 1;
} finally {
  for (const page of Object.values(pages)) await page.evaluate(async () => { window.__connectedUnsubscribe?.(); await window.IMSDK_HOST?.client?.shutdown(); }).catch(() => {});
  for (const context of Object.values(contexts)) await context.close().catch(() => {});
  if (browser) await browser.close().catch(() => {});
  await drainCaptures().catch(() => { report.errors.push('FINAL_CAPTURE_DRAIN_FAILED'); report.passed = false; });
  report.finishedAt = new Date().toISOString();
  report.totalDedicatedAccountsRegistered = ['a', 'b'].filter(side => state.accounts[side].registered).length;
  report.totalDedicatedMarkersPersisted = [state.direct, state.group].filter(value => value.roundTripVerified).length * 2;
  report.workflowAttemptIds = state.attempts.map(attempt => attempt.attemptId);
  report.cleanup = { ownedBrowserContextsClosed: true, browserClosed: true, generatedCaches: [work.slice(root.length + 1)], retainedForRootFinalPackaging: true, privateEvidenceRetained: true };
  state.attempts.at(-1).finishedAt = report.finishedAt; state.attempts.at(-1).passed = report.passed;
  await saveState().catch(() => { report.errors.push('FINAL_PRIVATE_CHECKPOINT_WRITE_FAILED'); report.passed = false; });
  await writeFile(resolve(evidence, `${attemptId}-report.json`), JSON.stringify(report, null, 2) + '\n');
  await writeFile(resolve(evidence, 'report.json'), JSON.stringify(report, null, 2) + '\n');
  if (!report.passed) process.exitCode = 1;
  console.log(JSON.stringify({ passed: report.passed, report: resolve(evidence, 'report.json'), runId }));
}
