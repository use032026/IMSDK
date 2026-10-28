import { chromium, expect } from '@playwright/test';
import { createServer } from 'node:http';
import { readFile, mkdir, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { createHash, randomUUID } from 'node:crypto';

// Real backend, no route interception, transport mocks or browser security bypass.
// Credentials come only from caller-supplied private files and stay in memory.
const args = process.argv.slice(2);
const option = name => { const index = args.indexOf(name); return index < 0 ? undefined : args[index + 1]; };
const fixturePath = option('--fixture');
const directPath = option('--direct');
const groupPath = option('--group');
if (!fixturePath || !directPath || !groupPath) throw new Error('Supply --fixture, --direct and --group private file paths');
const fixture = JSON.parse(await readFile(resolve(fixturePath), 'utf8'));
const direct = JSON.parse(await readFile(resolve(directPath), 'utf8'));
const group = JSON.parse(await readFile(resolve(groupPath), 'utf8'));
const loginOnly = args.includes('--login-only');
const runId = option('--run-id') ?? new Date().toISOString().replace(/[^0-9]/g, '').slice(0, 14);
if (!/^[a-zA-Z0-9_-]{1,50}$/.test(runId)) throw new Error('Invalid run id');
const evidence = resolve(option('--evidence') ?? `../logs/web-live-${runId}`);
await mkdir(evidence, { recursive: true });
const api = fixture.configuration.apiBaseUrl.replace(/\/+$/, '');
const source = fixture.source;
const peer = fixture.peer;
const report = {
  runId, realBackend: true, mockedResponses: false, securityBypass: false,
  startedAt: new Date().toISOString(), stages: [], requests: [], websocketFrames: [],
  passed: false, loginOnly, errors: [],
  scope: { existingDirectOnly: true, existingExactTwoMemberGroupOnly: true, newGroups: false, membersOrPermissionsChanged: false },
};
class Stop extends Error { constructor(code) { super(code); this.code = code; } }
const ensure = (condition, code) => { if (!condition) throw new Stop(code); };
const record = (stage, detail = {}) => {
  const event = { stage, at: new Date().toISOString(), ...detail };
  report.stages.push(event);
  console.log(JSON.stringify(event));
};
const hash = value => createHash('sha256').update(value).digest('hex');
const rows = value => Array.isArray(value) ? value : value?.items ?? [];
const text = value => { try { const body = typeof value.body === 'string' ? JSON.parse(value.body) : value.body; return body?.text; } catch { return undefined; } };
function claims(token) {
  try { return JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString('utf8')); } catch { return {}; }
}
async function request(path, { token, method = 'GET', body } = {}) {
  let response;
  try {
    response = await fetch(api + path, { method, headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}), ...(body === undefined ? {} : { 'Content-Type': 'application/json' }) },
      body: body === undefined ? undefined : JSON.stringify(body), signal: AbortSignal.timeout(20000), redirect: 'error' });
  } catch { throw new Stop(`PEER_TRANSPORT_${method}`); }
  let envelope;
  try { envelope = await response.json(); } catch { throw new Stop(`PEER_INVALID_JSON_HTTP_${response.status}`); }
  report.requests.push({ side: 'peer', path: path.split('?')[0], method, status: response.status, code: /^[A-Z0-9_.]{1,80}$/.test(envelope.code ?? '') ? envelope.code : 'unavailable' });
  ensure(response.ok && envelope.code === 'OK', `PEER_HTTP_${response.status}`);
  return envelope.data;
}
async function peerLogin() {
  const platform = await request('/api/platform/v1/auth/login', { method: 'POST', body: { identifier: peer.account, password: peer.password, loginType: 'lpp_id' } });
  ensure(platform.platformUserId === peer.platformUserId && platform.platformToken, 'PEER_PLATFORM_IDENTITY_MISMATCH');
  const selected = await request('/api/platform/v1/auth/select-personal-space', { method: 'POST', token: platform.platformToken });
  const profile = await request('/api/client/v1/profile/me', { token: selected.accessToken });
  const accepted = claims(selected.accessToken);
  ensure(profile.userId === peer.userId && selected.userId === peer.userId && selected.platformUserId === peer.platformUserId, 'PEER_PERSONAL_IDENTITY_MISMATCH');
  ensure(String(accepted.space_type) === '1' && accepted['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] === peer.userId && accepted.platform_user_id === peer.platformUserId, 'PEER_ACCEPTED_CLAIM_IDENTITY_MISMATCH');
  record('peerPasswordLoginVerified', { profileAccepted: true, personalSpace: true });
  return selected.accessToken;
}
async function verifyScope(token) {
  ensure(source.userId !== peer.userId && direct.sourceUserId === source.userId && direct.peerUserId === peer.userId && group.sourceUserId === source.userId && group.peerUserId === peer.userId && group.parentApproved === true, 'PRIVATE_SCOPE_BINDING_MISMATCH');
  let cursor;
  let found;
  for (let count = 0; count < 6; count++) {
    const page = await request('/api/client/v1/conversations?' + new URLSearchParams({ limit: '100', ...(cursor ? { cursor } : {}) }), { token });
    found = rows(page).find(item => item.conversationId === direct.conversationId && item.conversationType === 'direct' && item.peerUserId === source.userId);
    if (found || !page.nextCursor) break;
    cursor = page.nextCursor;
  }
  ensure(found, 'EXISTING_DIRECT_PAIR_NOT_VERIFIED');
  const detail = await request(`/api/client/v1/groups/${encodeURIComponent(group.groupId)}`, { token });
  const members = rows(await request(`/api/client/v1/groups/${encodeURIComponent(group.groupId)}/members`, { token }));
  const memberIds = members.map(item => item.userId || item.memberUserId || item.targetUserId || item.id || item.user?.userId || item.user?.id);
  ensure(detail.ownerUserId === source.userId && memberIds.length === 2 && new Set(memberIds).size === 2 && memberIds.includes(source.userId) && memberIds.includes(peer.userId), 'EXACT_TWO_MEMBER_GROUP_NOT_VERIFIED');
  record('existingConversationScopeVerified', { exactDirectPair: true, exactTwoGroupMembers: true, ownerMatchesSource: true });
}

const bundle = resolve(option('--bundle') ?? '../dist/web/im-sdk.js');
report.bundleSha256 = hash(await readFile(bundle));
const server = createServer(async (request, response) => {
  if (request.url === '/im-sdk.js') { response.setHeader('Content-Type', 'application/javascript'); response.end(await readFile(bundle)); return; }
  if (request.url !== '/') { response.writeHead(404).end(); return; }
  response.setHeader('Content-Type', 'text/html; charset=utf-8');
  response.end('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><title>Web SDK 真实服务联调</title><style>html,body{height:100%;margin:0;background:#f5f7fb}#chat{height:100dvh;max-width:560px;margin:auto}</style><div id="chat"></div><script src="/im-sdk.js"></script></html>');
});
await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
const origin = `http://127.0.0.1:${server.address().port}`;
report.browserOrigin = origin;
let browser;
let page;
try {
  browser = await chromium.launch({ channel: 'chrome', headless: true });
  const context = await browser.newContext({ viewport: { width: 430, height: 900 } });
  page = await context.newPage();
  report.browserVersion = browser.version();
  page.on('response', response => {
    const url = new URL(response.url());
    if (url.origin !== new URL(api).origin) return;
    report.requests.push({ side: 'browser', path: url.pathname, method: response.request().method(), status: response.status(),
      allowOrigin: response.headers()['access-control-allow-origin'] ?? null });
  });
  page.on('requestfailed', req => {
    const url = new URL(req.url());
    report.requests.push({ side: 'browser', path: url.pathname, method: req.method(), status: null,
      failure: req.failure()?.errorText === 'net::ERR_ABORTED' ? 'request-aborted' : 'transport-or-cors' });
  });
  page.on('pageerror', () => report.errors.push('UNHANDLED_PAGE_ERROR'));
  page.on('websocket', socket => {
    const path = new URL(socket.url()).pathname;
    socket.on('framereceived', event => {
      for (const item of String(event.payload).split('\x1e').filter(Boolean)) {
        try {
          const frame = JSON.parse(item);
          const outer = frame.arguments?.[0];
          const data = outer?.data ?? outer?.Data ?? outer;
          report.websocketFrames.push({ path, type: frame.type ?? 'handshake', target: typeof frame.target === 'string' ? frame.target : undefined,
            conversationId: typeof data?.conversationId === 'string' ? data.conversationId : undefined,
            messageId: typeof data?.messageId === 'string' ? data.messageId : undefined });
        } catch { /* Ignore non-JSON bytes without recording payloads. */ }
      }
    });
  });
  await page.goto(origin);
  await page.evaluate(config => {
    window.liveEvents = [];
    window.liveClient = new IMSDK.ImSdkClient();
    liveClient.on(event => liveEvents.push({ type: event.type, code: event.code, state: event.state }));
    liveClient.initialize(config);
    window.liveView = IMSDK.mountMessenger(liveClient, document.getElementById('chat'));
  }, { apiBaseUrl: api, ...(fixture.configuration.gatewayBaseUrl ? { gatewayBaseUrl: fixture.configuration.gatewayBaseUrl } : {}),
    serviceRealmId: fixture.configuration.serviceRealmId, passwordLogin: { space: 'personal', loginType: 'lpp_id' }, privacyConsentGranted: true,
    pollIntervalMs: 300000 });
  await page.getByPlaceholder('账号', { exact: true }).fill(source.account);
  await page.getByPlaceholder('密码', { exact: true }).fill(source.password);
  await page.getByRole('button', { name: '登录', exact: true }).click();
  await page.waitForFunction(() => liveClient.isAuthenticated || liveEvents.some(event => event.type === 'authenticationFailed'), undefined, { timeout: 25000 });
  const login = await page.evaluate(() => ({ authenticated: liveClient.isAuthenticated, user: liveClient.currentUser, events: liveEvents }));
  report.sdkEvents = login.events;
  ensure(login.authenticated, 'SDK_LOGIN_' + (login.events.findLast(event => event.type === 'authenticationFailed')?.code ?? 'INCOMPLETE'));
  ensure(login.user.userId === source.userId && login.user.platformUserId === source.platformUserId && login.user.spaceId === 'personal', 'SOURCE_AUTHENTICATED_IDENTITY_MISMATCH');
  record('browserPasswordLoginVerified', { sourceIdentityMatches: true, personalSpace: true, directCrossOrigin: true });
  await page.getByText('已连接', { exact: true }).waitFor({ timeout: 25000 });
  record('realSignalRConnected', { pollingIntervalMs: 300000 });
  if (!loginOnly) {
    const token = await peerLogin();
    await verifyScope(token);
    for (const [kind, id] of [['direct', direct.conversationId], ['group', group.groupId]]) {
      if (kind === 'group') await verifyScope(token);
      const base = `/api/client/v1/${kind === 'group' ? 'groups' : 'direct-chats'}/${encodeURIComponent(id)}/messages`;
      const outgoingText = `WEB-${kind.toUpperCase()}-${runId}`;
      const replyText = `WEB-${kind.toUpperCase()}-REPLY-${runId}`;
      const before = rows(await request(base + '?limit=100', { token }));
      ensure(!before.some(item => text(item) === outgoingText || text(item) === replyText), 'RUN_MARKER_ALREADY_EXISTS');
      await page.evaluate(target => liveView.openConversation(target), { conversationId: id, type: kind });
      await page.getByRole('textbox', { name: '消息内容' }).fill(outgoingText);
      await page.getByRole('button', { name: '发送', exact: true }).click();
      await expect(page.getByRole('textbox', { name: '消息内容' })).toHaveValue('', { timeout: 25000 });
      let outgoing;
      await expect.poll(async () => {
        const items = rows(await request(base + '?limit=100', { token }));
        const found = items.filter(item => item.senderUserId === source.userId && text(item) === outgoingText && item.messageId && Number(item.conversationSeq) > 0);
        ensure(found.length <= 1, 'DUPLICATE_SOURCE_MESSAGES');
        outgoing = found[0];
        return !!outgoing;
      }, { timeout: 25000, intervals: [1000, 2000, 3000] }).toBe(true);
      record(kind + 'BrowserSendPersisted', { messageId: outgoing.messageId, seq: outgoing.conversationSeq, exactSenderVerified: true, exactPersistedCount: 1 });
      const framesBefore = report.websocketFrames.length;
      await request(base, { token, method: 'POST', body: { clientMsgId: randomUUID(), messageType: 'text', body: { text: replyText }, replyToMessageId: outgoing.messageId, mentions: [] } });
      const after = rows(await request(base + '?limit=100', { token }));
      const replies = after.filter(item => item.senderUserId === peer.userId && text(item) === replyText && Number(item.conversationSeq) > Number(outgoing.conversationSeq));
      ensure(replies.length === 1, 'PEER_REPLY_NOT_PERSISTED_EXACTLY_ONCE');
      await page.getByText(replyText, { exact: true }).waitFor({ timeout: 20000 });
      ensure(report.websocketFrames.slice(framesBefore).some(frame => frame.target === 'msg.new'), 'REPLY_WITHOUT_REAL_MESSAGE_EVENT');
      await page.screenshot({ path: resolve(evidence, `${kind}-roundtrip.png`), fullPage: true });
      report[kind] = { sourceText: outgoingText, sourceMessageId: outgoing.messageId, sourceSeq: outgoing.conversationSeq,
        replyText, replyMessageId: replies[0].messageId, replySeq: replies[0].conversationSeq,
        sourcePersistedByPeerReadback: true, replyPersistedByPeerReadback: true, replyVisibleInBrowser: true, realMessageEventObserved: true };
      record(kind + 'RoundTripVerified', { replySeq: replies[0].conversationSeq, peerReadback: true, browserVisible: true, realMessageEvent: true });
    }
    await page.evaluate(() => { liveView.close(); window.liveView = IMSDK.mountMessenger(liveClient, document.getElementById('chat')); });
    ensure(await page.evaluate(() => liveClient.isAuthenticated), 'REOPEN_LOST_SESSION');
    record('samePageReopenVerified');
  }
  report.sdkEvents = await page.evaluate(() => liveEvents);
  await page.evaluate(() => liveClient.logout());
  await page.getByRole('button', { name: '登录', exact: true }).waitFor();
  await page.evaluate(() => liveClient.shutdown());
  record('logoutAndShutdownVerified');
  ensure(!report.errors.length, 'UNHANDLED_BROWSER_ERRORS');
  report.passed = true;
} catch (error) {
  const failure = error instanceof Stop ? error.code : `VALIDATION_${error?.name ?? 'ERROR'}`;
  report.errors.push(failure);
  record('validationStopped', { code: failure });
  if (page) {
    try {
      report.sdkEvents = await page.evaluate(() => window.liveEvents ?? []);
      const notice = await page.locator('[role="alert"]').allTextContents();
      report.publicSdkNotice = notice;
      await page.screenshot({ path: resolve(evidence, 'failure.png'), fullPage: true, mask: [page.getByPlaceholder('账号', { exact: true }), page.getByPlaceholder('密码', { exact: true })] });
    } catch { /* Save structured evidence even if the page is unavailable. */ }
  }
  process.exitCode = 1;
} finally {
  if (page) await page.evaluate(() => window.liveClient?.shutdown()).catch(() => {});
  if (browser) await browser.close();
  await new Promise(resolve => server.close(resolve));
  report.finishedAt = new Date().toISOString();
  await writeFile(resolve(evidence, 'report.json'), JSON.stringify(report, null, 2));
  console.log(JSON.stringify({ report: resolve(evidence, 'report.json'), passed: report.passed }));
}
