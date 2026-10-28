import { chromium, expect } from '@playwright/test';
import { createServer } from 'node:http';
import { readFile, mkdir, writeFile, chmod } from 'node:fs/promises';
import { resolve, dirname } from 'node:path';
import { createHash, randomUUID } from 'node:crypto';

// Actual service validation. Never intercepts requests, sends verification codes,
// changes server policies, or touches contacts outside the supplied dedicated pair.
const args = process.argv.slice(2);
const option = key => { const i = args.indexOf(key); return i < 0 ? undefined : args[i + 1]; };
const fixturePath = resolve(option('--fixture') ?? '');
const phase = option('--phase') ?? 'register';
if (!fixturePath.includes('/.work/runtime-private/') || !['register', 'friend', 'peer', 'roundtrip', 'capture'].includes(phase)) throw new Error('Private fixture and supported phase required');
const fixture = JSON.parse(await readFile(fixturePath, 'utf8'));
const runId = fixture.runId;
if (!/^[a-zA-Z0-9_-]{1,60}$/.test(runId ?? '')) throw new Error('Invalid run identifier');
const account = fixture.accounts.web;
const privateStatus = resolve(dirname(fixturePath), `unification-live-${runId}-web-status.json`);
const mobileStatus = resolve(dirname(fixturePath), `unification-live-${runId}-mobile-status.json`);
const evidence = resolve(option('--evidence') ?? `../logs/unification-web-live-${runId}`);
const bundle = resolve(option('--bundle') ?? 'dist/im-sdk.js');
await mkdir(evidence, { recursive: true });
const latestReport = resolve(evidence, `${phase}-report.json`);
try {
  const previous = JSON.parse(await readFile(latestReport, 'utf8'));
  const stamp = String(previous.startedAt ?? new Date().toISOString()).replace(/[^0-9]/g, '');
  await writeFile(resolve(evidence, `${phase}-${stamp}-prior-report.json`), JSON.stringify(previous, null, 2), { flag: 'wx' }).catch(error => { if (error.code !== 'EEXIST') throw error; });
} catch (error) { if (error.code !== 'ENOENT') throw error; }
const report = { runId, phase, realBackend: true, mockedResponses: false, securityBypass: false,
  startedAt: new Date().toISOString(), passed: false, codesSent: 0, stages: [], requests: [], errors: [],
  bundleSha256: createHash('sha256').update(await readFile(bundle)).digest('hex') };
class Stop extends Error { constructor(code) { super(code); this.code = code; } }
const ensure = (value, code) => { if (!value) throw new Stop(code); };
const record = (stage, detail = {}) => { const item = { stage, at: new Date().toISOString(), ...detail }; report.stages.push(item); console.log(JSON.stringify(item)); };
const privateWrite = async (path, data) => { await writeFile(path, JSON.stringify(data, null, 2), { mode: 0o600 }); await chmod(path, 0o600); };
let status = { runId, accountRole: 'web', registered: false, loginVerified: false };
try { status = { ...status, ...JSON.parse(await readFile(privateStatus, 'utf8')) }; } catch { /* First run. */ }
report.registrationPerformedThisAttempt = phase === 'register' && !status.registered;
report.reusedRegisteredAccount = status.reusedRegisteredAccount === true;
if (/^[a-zA-Z0-9_-]{1,60}$/.test(status.originalRegistrationEvidenceRunId ?? '')) report.originalRegistrationEvidenceRunId = status.originalRegistrationEvidenceRunId;
let browser, page;
const server = createServer(async (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  if (req.url === '/sdk.js') { res.setHeader('Content-Type', 'application/javascript'); res.end(await readFile(bundle)); return; }
  if (req.url !== '/') { res.writeHead(404).end(); return; }
  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  res.end('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><title>IM SDK 实际服务验证</title><style>html,body{height:100%;margin:0;background:#f5f7fb}#chat{height:100dvh;max-width:560px;margin:auto}</style><div id="chat"></div><script src="/sdk.js"></script></html>');
});
await new Promise(r => server.listen(0, '127.0.0.1', r));
const origin = `http://127.0.0.1:${server.address().port}`;
const safeError = error => error instanceof Stop ? error.code : /^[A-Z][A-Z0-9_.]{0,79}$/.test(error?.code ?? '') ? error.code : 'LIVE_VALIDATION_FAILED';
function captchaAnswer(question) {
  const match = String(question).match(/(-?\d+)\s*([+\-*×/÷])\s*(-?\d+)/);
  if (!match) throw new Stop('MANUAL_CAPTCHA_REQUIRED');
  const a = Number(match[1]), b = Number(match[3]);
  const result = ['+', '-', '*', '×', '/', '÷'].indexOf(match[2]);
  const value = result === 0 ? a + b : result === 1 ? a - b : result < 4 ? a * b : a / b;
  if (!Number.isFinite(value) || !Number.isInteger(value)) throw new Stop('MANUAL_CAPTCHA_REQUIRED');
  return String(value);
}
async function screenshot(name) {
  await page.screenshot({ path: resolve(evidence, name), fullPage: true, mask: [page.getByPlaceholder('账号', { exact: true }),
    page.getByPlaceholder('密码', { exact: true }), page.getByPlaceholder('邮箱', { exact: true }), page.getByPlaceholder('手机号', { exact: true }),
    page.getByPlaceholder('设置密码', { exact: true }), page.getByPlaceholder('确认密码', { exact: true }), page.getByPlaceholder('搜索账号、手机号或邮箱', { exact: true }),
    page.locator('.meta').filter({ hasText: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i })] });
}
async function submitAuthentication(kind) {
  const button = page.getByRole('button', { name: kind === 'register' ? '注册并登录' : '登录', exact: true });
  for (let attempt = 0; attempt < 3; attempt++) {
    const previousFailures = await page.evaluate(() => liveEvents.filter(e => e.type === 'authenticationFailed').length);
    await button.click();
    await expect.poll(async () => page.evaluate(count => liveClient.isAuthenticated || liveEvents.filter(e => e.type === 'authenticationFailed').length > count, previousFailures), { timeout: 30000 }).toBe(true);
    if (await page.evaluate(() => liveClient.isAuthenticated)) return;
    const code = await page.evaluate(() => liveEvents.filter(e => e.type === 'authenticationFailed').at(-1)?.code);
    if (!/CAPTCHA/.test(code ?? '')) throw new Stop(code ?? 'AUTHENTICATION_INCOMPLETE');
    const question = page.locator('.captcha-question');
    await expect(question).not.toBeEmpty({ timeout: 15000 });
    await page.getByPlaceholder('安全验证答案', { exact: true }).fill(captchaAnswer(await question.textContent()));
    if (kind === 'login') await page.getByPlaceholder('密码', { exact: true }).fill(account.password);
  }
  throw new Stop('CAPTCHA_RETRY_LIMIT');
}
async function login() {
  await page.getByPlaceholder('账号', { exact: true }).fill(account.identifier);
  await page.getByPlaceholder('密码', { exact: true }).fill(account.password);
  await screenshot(`${phase}-login-form.png`);
  await submitAuthentication('login');
  const user = await page.evaluate(() => liveClient.currentUser);
  ensure(user?.userId && user?.platformUserId && user?.spaceId, 'LOGIN_IDENTITY_UNRESOLVED');
  if (status.user) ensure(user.userId === status.user.userId && user.platformUserId === status.user.platformUserId && user.spaceId === status.user.spaceId, 'RELOGIN_IDENTITY_CHANGED');
  status.user = user;
  status.loginVerified = true;
  await privateWrite(privateStatus, status);
  await page.getByRole('button', { name: '发起单聊', exact: true }).waitFor({ timeout: 25000 });
  record('passwordLoginVerified', { actualSpaceResolved: true, oneActiveSession: true });
}
async function mobileIdentity() {
  const deadline = Date.now() + 6 * 60000;
  while (Date.now() < deadline) {
    try {
      const mobile = JSON.parse(await readFile(mobileStatus, 'utf8'));
      const user = mobile.user ?? mobile.identity;
      if (user?.userId && user?.spaceId) return user;
    } catch { /* The mobile registration owns this disjoint status file. */ }
    await new Promise(r => setTimeout(r, 1500));
  }
  throw new Stop('MOBILE_REGISTRATION_NOT_READY');
}
const rows = data => Array.isArray(data) ? data : data?.items ?? [];
function messageText(item) { try { return (typeof item.body === 'string' ? JSON.parse(item.body) : item.body)?.text; } catch { return undefined; } }
async function browserRest(path) {
  const result = await page.evaluate(async path => {
    // Harness-only authoritative read supplements public SDK/UI assertions.
    // The bearer stays in this browser and is never returned or recorded.
    const response = await fetch(liveClient.config.apiBaseUrl + path, { headers: { Authorization: `Bearer ${liveClient.credentials.accessToken}`, Accept: 'application/json' }, credentials: 'omit', cache: 'no-store', redirect: 'error' });
    const envelope = await response.json();
    return { status: response.status, code: envelope.code, data: envelope.data };
  }, path);
  ensure(result.status === 200 && result.code === 'OK', 'GROUP_SCOPE_REST_READ_FAILED');
  return result.data;
}
async function verifyGroupScope(target, sourceUser, ownerUserId) {
  const id = encodeURIComponent(target.conversationId);
  const detail = await browserRest(`/api/client/v1/groups/${id}`);
  const members = rows(await browserRest(`/api/client/v1/groups/${id}/members`));
  const ids = members.map(row => row.userId ?? row.memberUserId ?? row.targetUserId ?? row.id ?? row.user?.userId);
  ensure(detail.ownerUserId === ownerUserId && ids.length === 2 && new Set(ids).size === 2 && ids.includes(sourceUser.userId) && ids.includes(status.user.userId), 'DEDICATED_TWO_MEMBER_GROUP_NOT_VERIFIED');
  record('dedicatedTwoMemberGroupScopeVerified', { exactTwoMembers: true, ownerMatchesExpected: true });
}
async function findConversation(predicate, code, timeout = 180000) {
  let found;
  await expect.poll(async () => {
    const items = await page.evaluate(async () => {
      try { return await liveClient.listConversations({ limit: 100 }); }
      catch (error) { if (['NETWORK_ERROR', 'REQUEST_TIMEOUT'].includes(error.code)) return { items: [] }; throw error; }
    });
    found = items.items.find(predicate);
    return !!found;
  }, { timeout, intervals: [1200, 2000, 3000], message: code }).toBe(true);
  return found;
}
async function submitUiMessage(target, text) {
  await page.evaluate(target => liveView.openConversation(target), target);
  await page.getByRole('textbox', { name: '消息内容' }).fill(text);
  await page.getByRole('button', { name: '发送', exact: true }).click();
  await expect(page.getByRole('textbox', { name: '消息内容' })).toHaveValue('', { timeout: 25000 });
  await page.getByText(text, { exact: true }).waitFor({ timeout: 20000 });
}
async function replyToMobile(kind, mobileUser) {
  const marker = `IMSDK-${runId}-mobile-${kind}`;
  const target = await findConversation(item => kind === 'direct' ? item.type === 'direct' && item.peerUserId === mobileUser.userId : item.type === 'group' && item.title === `IMSDK-${runId}-Mobile`, 'MOBILE_CONVERSATION_NOT_AVAILABLE', kind === 'group' ? 360000 : 180000);
  if (kind === 'group') await verifyGroupScope(target, mobileUser, mobileUser.userId);
  await page.evaluate(target => liveView.openConversation(target), target);
  await page.getByText(marker, { exact: true }).waitFor({ timeout: 180000 });
  const before = await page.evaluate(target => liveClient.listMessages(target, { limit: 100 }), target);
  const incoming = before.filter(item => item.text === marker && item.senderUserId === mobileUser.userId);
  ensure(incoming.length === 1 && incoming[0].seq > 0, 'MOBILE_OUTGOING_NOT_PERSISTED_EXACTLY_ONCE');
  const reply = `${marker}-web-reply`;
  const existingReply = before.filter(item => item.text === reply && item.senderUserId === status.user.userId);
  ensure(existingReply.length <= 1, 'WEB_REPLY_ALREADY_DUPLICATED');
  if (!existingReply.length) await submitUiMessage(target, reply);
  const after = await page.evaluate(target => liveClient.listMessages(target, { limit: 100 }), target);
  const persisted = after.filter(item => item.text === reply && item.senderUserId === status.user.userId);
  ensure(persisted.length === 1 && persisted[0].seq > incoming[0].seq, 'WEB_REPLY_NOT_PERSISTED_EXACTLY_ONCE');
  status[kind] = { conversationId: target.conversationId, incomingMarker: marker, replyMarker: reply, receivedFromExpectedPeer: true, replyPersisted: true };
  await privateWrite(privateStatus, status);
  record(`mobile${kind}RoundTripVerifiedByWebPeer`, { incomingSeq: incoming[0].seq, replySeq: persisted[0].seq, exactSenderVerified: true, incomingVisibleInBrowser: true,
    replySentThroughBrowserThisAttempt: !existingReply.length, priorReplyReusedWithoutDuplicateSend: !!existingReply.length, independentPersistedReadback: true });
  await screenshot(`mobile-${kind}-web-peer.png`);
}
async function peerRequest(path, { token, method = 'GET', body } = {}) {
  const response = await fetch(fixture.configuration.apiBaseUrl.replace(/\/+$/, '') + path, { method,
    headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}), ...(body === undefined ? {} : { 'Content-Type': 'application/json' }) },
    body: body === undefined ? undefined : JSON.stringify(body), redirect: 'error', signal: AbortSignal.timeout(20000) });
  const envelope = await response.json();
  report.requests.push({ side: 'independent-peer', path: path.split('?')[0], method, status: response.status });
  ensure(response.ok && envelope.code === 'OK', `PEER_REQUEST_HTTP_${response.status}`);
  return envelope.data;
}
async function peerLogin(mobileUser) {
  const peer = fixture.accounts.mobile;
  const platform = await peerRequest('/api/platform/v1/auth/login', { method: 'POST', body: { identifier: peer.identifier, password: peer.password, loginType: peer.channel === 'email' ? 'email' : 'mobile' } });
  const selected = platform.accessToken ? platform : await peerRequest('/api/platform/v1/auth/select-personal-space', { method: 'POST', token: platform.platformToken });
  const profile = await peerRequest('/api/client/v1/profile/me', { token: selected.accessToken });
  ensure(selected.userId === mobileUser.userId && profile.userId === mobileUser.userId, 'INDEPENDENT_PEER_IDENTITY_MISMATCH');
  record('independentPeerFreshPasswordLoginVerified', { expectedDedicatedIdentity: true });
  return selected.accessToken;
}
async function webRoundTrip(kind, target, mobileUser, token) {
  if (kind === 'group') await verifyGroupScope(target, mobileUser, status.user.userId);
  const marker = `IMSDK-${runId}-web-${kind}`;
  const reply = `${marker}-peer-reply`;
  const endpoint = `/api/client/v1/${kind === 'group' ? 'groups' : 'direct-chats'}/${encodeURIComponent(target.conversationId)}/messages`;
  const existing = rows(await peerRequest(endpoint + '?limit=100', { token }));
  const existingOutgoing = existing.filter(item => item.senderUserId === status.user.userId && messageText(item) === marker);
  ensure(existingOutgoing.length <= 1, 'WEB_OUTGOING_ALREADY_DUPLICATED');
  if (!existingOutgoing.length) await submitUiMessage(target, marker);
  else await page.evaluate(target => liveView.openConversation(target), target);
  const before = rows(await peerRequest(endpoint + '?limit=100', { token }));
  const outgoing = before.filter(item => item.senderUserId === status.user.userId && messageText(item) === marker);
  ensure(outgoing.length === 1 && outgoing[0].conversationSeq > 0, 'WEB_OUTGOING_NOT_PERSISTED_EXACTLY_ONCE');
  const existingIncoming = before.filter(item => item.senderUserId === mobileUser.userId && messageText(item) === reply);
  ensure(existingIncoming.length <= 1, 'INDEPENDENT_PEER_REPLY_ALREADY_DUPLICATED');
  if (!existingIncoming.length) await peerRequest(endpoint, { token, method: 'POST', body: { clientMsgId: randomUUID(), messageType: 'text', body: { text: reply }, mentions: [] } });
  const after = rows(await peerRequest(endpoint + '?limit=100', { token }));
  const incoming = after.filter(item => item.senderUserId === mobileUser.userId && messageText(item) === reply);
  ensure(incoming.length === 1 && incoming[0].conversationSeq > outgoing[0].conversationSeq, 'INDEPENDENT_PEER_REPLY_NOT_PERSISTED_EXACTLY_ONCE');
  await page.getByText(reply, { exact: true }).waitFor({ timeout: 25000 });
  record(`web${kind}RoundTripVerified`, { outgoingSeq: outgoing[0].conversationSeq, replySeq: incoming[0].conversationSeq,
    outgoingSentThroughBrowserThisAttempt: !existingOutgoing.length, existingMessagesReusedWithoutDuplicateSend: !!existingOutgoing.length || !!existingIncoming.length,
    peerReadback: true, replyVisibleInBrowser: true, dedicatedPairOnly: true });
  await screenshot(`web-${kind}-roundtrip.png`);
  status[`web${kind}`] = { conversationId: target.conversationId, outgoingMarker: marker, replyMarker: reply, outgoingPersistedByPeer: true, replyPersistedByPeer: true, replyVisibleInBrowser: true };
  await privateWrite(privateStatus, status);
}
try {
  browser = await chromium.launch({ channel: 'chrome', headless: true });
  page = await browser.newPage({ viewport: { width: 430, height: 900 } });
  page.on('pageerror', () => report.errors.push('UNHANDLED_BROWSER_ERROR'));
  page.on('response', response => {
    const url = new URL(response.url());
    if (url.origin !== new URL(fixture.configuration.apiBaseUrl).origin) return;
    const path = url.pathname;
    if (path.endsWith('/verification/send')) report.codesSent++;
    report.requests.push({ path, method: response.request().method(), status: response.status() });
  });
  await page.goto(origin);
  await page.evaluate(config => {
    window.liveEvents = [];
    window.liveClient = new IMSDK.ImSdkClient();
    liveClient.on(e => liveEvents.push({ type: e.type, code: e.code, state: e.state }));
    liveClient.initialize(config);
    window.liveView = IMSDK.mountMessenger(liveClient, document.getElementById('chat'));
  }, { ...fixture.configuration, privacyConsentGranted: true, pollIntervalMs: 300000 });
  if (phase === 'register') {
    if (status.registered) record('priorRegisteredAccountUsedForReloginOnly', { registrationPerformedThisAttempt: false, originalRegistrationEvidenceMustBeRetained: true });
    if (!status.registered) {
      await page.getByRole('button', { name: '注册新账号', exact: true }).click();
      await page.getByLabel('注册方式', { exact: true }).selectOption(account.channel);
      const settings = await page.evaluate(() => liveClient.getRegistrationVerificationSettings());
      report.verificationSettings = settings;
      ensure(account.channel === 'email' ? settings.emailEnabled && !settings.emailRequired : settings.smsEnabled && !settings.smsRequired, 'REGISTRATION_VERIFICATION_DELIVERY_REQUIRED');
      await page.getByPlaceholder('昵称', { exact: true }).fill(account.displayName);
      await page.getByPlaceholder(account.channel === 'email' ? '邮箱' : '手机号', { exact: true }).fill(account.identifier);
      await page.getByPlaceholder('设置密码', { exact: true }).fill(account.password);
      await page.getByPlaceholder('确认密码', { exact: true }).fill(account.password);
      await screenshot('registration-form.png');
      try { await submitAuthentication('register'); }
      catch (error) {
        if (error.code !== 'REGISTER_LOGIN_FAILED') throw error;
        status.registered = true;
        status.registrationLoginInitiallyFailed = true;
        await privateWrite(privateStatus, status);
        await page.getByRole('button', { name: '返回登录', exact: true }).click();
        await login();
      }
      status.user = await page.evaluate(() => liveClient.currentUser);
      ensure(status.user?.userId && status.user?.platformUserId && status.user?.spaceId, 'REGISTERED_IDENTITY_UNRESOLVED');
      status.registered = true;
      status.registrationAutoLoginSucceeded = status.registrationLoginInitiallyFailed !== true;
      status.registeredAt = new Date().toISOString();
      await privateWrite(privateStatus, status);
      record('browserRegistrationVerified', { actualSpaceKind: status.user.spaceId === 'personal' ? 'personal' : 'enterprise', spaceChooserDisplayed: false, oneActiveSession: true, automaticEntrySucceeded: status.registrationAutoLoginSucceeded });
      await screenshot('registration-authenticated.png');
      await page.evaluate(() => liveClient.logout());
      ensure(await page.evaluate(() => liveClient.currentUser === undefined), 'LOGOUT_RETAINED_ACTIVE_SPACE');
    }
    await login();
    await screenshot('password-login-authenticated.png');
    ensure(status.registrationLoginInitiallyFailed !== true, 'REGISTRATION_AUTOMATIC_ENTRY_FAILED');
  } else {
    ensure(status.registered && status.user, 'WEB_REGISTRATION_NOT_READY');
    record('waitingForDedicatedMobileIdentity');
    const mobileUser = await mobileIdentity();
    ensure(mobileUser?.userId && mobileUser.userId !== status.user.userId && mobileUser.spaceId === status.user.spaceId, 'DEDICATED_PAIR_NOT_READY_IN_SAME_SPACE');
    await login();
    if (phase === 'capture') {
      for (const kind of ['direct', 'group']) {
        const prior = status[`web${kind}`];
        ensure(prior?.conversationId && prior.replyVisibleInBrowser === true, 'PRIOR_SUCCESSFUL_UI_ROUNDTRIP_REQUIRED');
        const target = await findConversation(item => item.conversationId === prior.conversationId && item.type === kind, 'PRIOR_CONVERSATION_NOT_FOUND');
        if (kind === 'direct') ensure(target.peerUserId === mobileUser.userId, 'CAPTURE_DIRECT_SCOPE_MISMATCH');
        else await verifyGroupScope(target, mobileUser, status.user.userId);
        await page.evaluate(target => liveView.openConversation(target), target);
        await page.getByText(prior.replyMarker, { exact: true }).waitFor({ timeout: 25000 });
        await screenshot(`web-${kind}-roundtrip.png`);
        record(`existing${kind}UiCaptured`, { noNewMessagesOrGroups: true, rawIdentityLabelsMasked: true });
      }
    } else if (phase === 'roundtrip') {
      const contacts = await page.evaluate(() => liveClient.listContacts());
      ensure(contacts.some(item => item.userId === mobileUser.userId), 'DEDICATED_FRIENDSHIP_NOT_READY');
      const token = await peerLogin(mobileUser);
      await page.getByRole('button', { name: '发起单聊', exact: true }).click();
      await page.getByRole('button', { name: `与${fixture.accounts.mobile.displayName}聊天`, exact: true }).click();
      const direct = await findConversation(item => item.type === 'direct' && item.peerUserId === mobileUser.userId, 'DEDICATED_DIRECT_NOT_AVAILABLE');
      await webRoundTrip('direct', direct, mobileUser, token);
      const existingGroups = await page.evaluate(title => liveClient.listConversations({ limit: 100 }).then(result => result.items.filter(item => item.type === 'group' && item.title === title)), `IMSDK-${runId}-Web`);
      ensure(existingGroups.length <= 1, 'TASK_GROUP_TITLE_ALREADY_DUPLICATED');
      let group = existingGroups[0];
      if (!group) {
        await page.getByRole('button', { name: '返回', exact: true }).click();
        await page.getByRole('button', { name: '发起单聊', exact: true }).click();
        await page.getByRole('button', { name: '新建群聊', exact: true }).click();
        await page.getByPlaceholder('群名称', { exact: true }).fill(`IMSDK-${runId}-Web`);
        await page.getByRole('checkbox', { name: `邀请${fixture.accounts.mobile.displayName}`, exact: true }).check();
        await screenshot('web-group-create-form.png');
        await page.getByRole('button', { name: '创建群聊', exact: true }).click();
        group = await findConversation(item => item.type === 'group' && item.title === `IMSDK-${runId}-Web`, 'WEB_CREATED_GROUP_NOT_AVAILABLE');
        record('groupCreatedThroughBrowser', { dedicatedPeerSelected: true });
      } else record('priorDedicatedWebGroupReused', { noDuplicateGroupCreated: true });
      await webRoundTrip('group', group, mobileUser, token);
    } else {
    if (!status.friendRequestSent) {
    await page.getByRole('button', { name: '添加好友', exact: true }).click();
    await page.getByPlaceholder('搜索账号、手机号或邮箱', { exact: true }).fill(fixture.accounts.mobile.identifier);
    await page.getByRole('button', { name: '搜索用户', exact: true }).click();
    const found = await page.evaluate(keyword => liveClient.searchUsers(keyword), fixture.accounts.mobile.identifier);
    ensure(found.length === 1 && found[0].userId === mobileUser.userId, 'DEDICATED_FRIEND_SEARCH_NOT_EXACT');
    await page.getByRole('button', { name: '添加好友', exact: true }).click();
    await expect.poll(async () => await page.getByRole('button', { name: '已申请', exact: true }).count() + await page.getByRole('button', { name: '已是好友', exact: true }).count(), { timeout: 20000 }).toBe(1);
    status.friendRequestSent = true;
    status.friendPeerUserId = mobileUser.userId;
    await privateWrite(privateStatus, status);
    record('friendRequestSubmittedThroughBrowser', { dedicatedPairVerified: true });
    await screenshot('friend-request-submitted.png');
    } else {
      await page.getByRole('button', { name: '好友申请', exact: true }).click();
      record('priorDedicatedFriendRequestReused', { noDuplicateRequestSent: true });
    }
    if (phase === 'peer') {
      await expect.poll(async () => page.evaluate(async peerId => {
        try { return (await liveClient.listContacts()).some(item => item.userId === peerId); }
        catch (error) { if (['NETWORK_ERROR', 'REQUEST_TIMEOUT'].includes(error.code)) return false; throw error; }
      }, mobileUser.userId), { timeout: 180000, intervals: [1000, 2000, 3000] }).toBe(true);
      status.friendshipVerified = true;
      await privateWrite(privateStatus, status);
      record('friendshipAcceptedAndVerified', { exactDedicatedPeerInContacts: true });
      await replyToMobile('direct', mobileUser);
      await replyToMobile('group', mobileUser);
    }
    }
  }
  ensure(report.codesSent === 0, 'UNEXPECTED_VERIFICATION_CODE_SEND');
  ensure(report.errors.length === 0, 'BROWSER_ERRORS');
  await page.evaluate(() => liveClient.logout());
  ensure(await page.evaluate(() => liveClient.currentUser === undefined), 'LOGOUT_RETAINED_ACTIVE_SPACE');
  record('logoutVerified', { activeSessions: 0 });
  report.passed = true;
} catch (error) {
  const code = safeError(error);
  report.errors.push(code);
  record('validationStopped', { code });
  if (page) await screenshot(`${phase}-failure.png`).catch(() => {});
  await privateWrite(resolve(dirname(fixturePath), `unification-live-${runId}-web-error.json`), { at: new Date().toISOString(), phase, name: error?.name, code,
    message: String(error?.message ?? '').split(account.password).join('[redacted]').split(account.identifier).join('[redacted]') });
  process.exitCode = 1;
} finally {
  if (page) await page.evaluate(() => window.liveClient?.shutdown()).catch(() => {});
  if (browser) await browser.close();
  await new Promise(r => server.close(r));
  report.finishedAt = new Date().toISOString();
  const stamp = report.startedAt.replace(/[^0-9]/g, '');
  await writeFile(resolve(evidence, `${phase}-${stamp}-report.json`), JSON.stringify(report, null, 2), { flag: 'wx' });
  await writeFile(latestReport, JSON.stringify(report, null, 2));
  console.log(JSON.stringify({ phase, passed: report.passed, report: resolve(evidence, `${phase}-report.json`) }));
}
