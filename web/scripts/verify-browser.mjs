import { chromium, expect } from '@playwright/test';
import { createServer } from 'node:http';
import { readFile, mkdir, writeFile } from 'node:fs/promises';
import { resolve, sep } from 'node:path';
import assert from 'node:assert/strict';

// A browser contract fixture, never a substitute for a live backend acceptance run.
const evidence = resolve('../logs/web-sdk-20261027');
await mkdir(evidence, { recursive: true });
const root = resolve('.');
const server = createServer(async (request, response) => {
  const pathname = new URL(request.url, 'http://localhost').pathname;
  const path = resolve(root, `.${pathname === '/' ? '/example/index.html' : pathname}`);
  if (!path.startsWith(root + sep)) { response.writeHead(403).end(); return; }
  try {
    response.setHeader('Content-Type', path.endsWith('.js') ? 'application/javascript' : 'text/html; charset=utf-8');
    response.end(await readFile(path));
  } catch { response.writeHead(404).end(); }
});
await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
const url = `http://127.0.0.1:${server.address().port}`;
const browser = await chromium.launch({ channel: 'chrome', headless: true });
const report = { fixture: true, liveBackend: false, checks: [], browsers: [], errors: [] };
try {
  for (const viewport of [{ width: 1280, height: 900 }, { width: 390, height: 844 }]) {
    const context = await browser.newContext({ viewport, isMobile: viewport.width < 500, deviceScaleFactor: 1 });
    const page = await context.newPage();
    const pageErrors = [];
    page.on('pageerror', error => pageErrors.push(error.message));
    let socket;
    let connects = 0;
    let messageNumber = 3;
    let failNextSend = false;
    const submittedIds = [];
    const direct = [{ messageId: 'm1', conversationId: 'chat-1', conversationSeq: 1, senderUserId: 'peer-1', messageType: 'text', body: { text: '<img src=x onerror="window.fixtureXss=true">' }, sentAt: '2026-10-27T09:00:00Z' }];
    const group = [{ messageId: 'm2', conversationId: 'group-1', conversationSeq: 1, senderUserId: 'peer-2', senderDisplayName: '小林', messageType: 'text', body: { text: '群聊历史' }, sentAt: '2026-10-27T09:01:00Z' }];
    const conversations = [
      { conversationId: 'chat-1', conversationType: 'direct', title: '同事', unreadCount: 1, lastMessage: { preview: '单聊历史' } },
      { conversationId: 'group-1', conversationType: 'group', title: '项目讨论', unreadCount: 1, lastMessage: { preview: '群聊历史' } },
    ];
    const identity = { platformUserId: 'platform-1', userId: 'user-1' };
    await page.route('https://api.example.test/**', async route => {
      const request = route.request();
      const path = new URL(request.url()).pathname;
      const body = request.postDataJSON();
      let data;
      if (path.endsWith('/negotiate')) data = { negotiateVersion: 1, connectionId: `fixture-${connects}`, connectionToken: 'fixture', availableTransports: [{ transport: 'WebSockets', transferFormats: ['Text', 'Binary'] }] };
      else if (path.endsWith('/platform/v1/auth/login')) data = { ...identity, platformToken: 'fixture-platform-token' };
      else if (path.endsWith('/select-personal-space')) data = { ...identity, spaceContext: { spaceType: 1 }, accessToken: 'fixture-token', refreshToken: 'fixture-refresh', expiresIn: 3600 };
      else if (path.endsWith('/profile/me')) data = identity;
      else if (path.endsWith('/conversations')) data = { items: conversations };
      else if (path.endsWith('/friends')) data = [{ friendUserId: 'peer-1', displayName: '同事' }];
      else if (path.endsWith('/direct-chats')) { assert.equal(body.peerUserId, 'peer-1'); data = { conversationId: 'chat-1', title: '同事' }; }
      else if (path.endsWith('/read')) data = {};
      else if (path.endsWith('/contact-brand')) data = { threadId: 'thread-1', threadStatus: 'queued', conversationId: 'must-not-open' };
      else if (path.endsWith('/messages')) {
        const messages = path.includes('/groups/') ? group : direct;
        if (request.method() === 'POST') {
          submittedIds.push(body.clientMsgId);
          if (failNextSend) { failNextSend = false; await route.abort('failed'); return; }
          const next = { messageId: `m${messageNumber++}`, conversationId: path.includes('/groups/') ? 'group-1' : 'chat-1', conversationSeq: messages.length + 1, senderUserId: 'user-1', messageType: 'text', body: body.body, sentAt: '2026-10-27T09:05:00Z' };
          messages.push(next);
          data = { messageId: next.messageId, conversationSeq: next.conversationSeq, serverTime: next.sentAt };
        } else data = messages;
      } else throw new Error(`Unexpected fixture request: ${path}`);
      await route.fulfill({ json: path.endsWith('/negotiate') ? data : { code: 'OK', data } });
    });
    await page.routeWebSocket('wss://api.example.test/ws/client*', ws => {
      socket = ws;
      connects++;
      ws.onMessage(value => {
        for (const frame of String(value).split('\x1e').filter(Boolean)) {
          const data = JSON.parse(frame);
          if (data.protocol) ws.send('{}\x1e');
          else if (data.invocationId) ws.send(JSON.stringify({ type: 3, invocationId: data.invocationId }) + '\x1e');
        }
      });
    });
    await page.goto(url);
    await page.getByLabel('IM API 服务地址', { exact: true }).fill('https://api.example.test');
    await page.getByLabel('服务环境标识').fill('fixture-realm');
    await page.getByRole('checkbox').check();
    await page.getByRole('button', { name: '初始化并打开聊天' }).click();
    await page.getByPlaceholder('账号', { exact: true }).fill('fixture-user');
    await page.getByPlaceholder('密码', { exact: true }).fill('fixture-password');
    await page.getByRole('button', { name: '登录', exact: true }).click();
    await page.getByRole('button', { name: /同事，/ }).waitFor();
    await page.getByText('已连接', { exact: true }).waitFor();
    assert.equal(connects, 1);
    await page.getByRole('button', { name: '发起单聊', exact: true }).click();
    await page.getByRole('button', { name: '与同事聊天', exact: true }).click();
    await page.getByText('<img src=x onerror="window.fixtureXss=true">', { exact: true }).waitFor();
    await page.getByRole('button', { name: '返回', exact: true }).click();
    await page.getByRole('button', { name: /同事，/ }).click();
    await page.getByText('<img src=x onerror="window.fixtureXss=true">', { exact: true }).waitFor();
    assert.equal(await page.evaluate(() => window.fixtureXss), undefined);
    await page.getByRole('textbox', { name: '消息内容' }).fill('  单聊发送保留空格  ');
    await page.getByRole('button', { name: '发送', exact: true }).click();
    await page.getByText('单聊发送保留空格', { exact: true }).waitFor();
    assert.equal(direct.at(-1).body.text, '  单聊发送保留空格  ');
    failNextSend = true;
    await page.getByRole('textbox', { name: '消息内容' }).fill('失败后重试');
    await page.getByRole('button', { name: '发送', exact: true }).click();
    await page.getByRole('alert').filter({ hasText: '网络连接失败' }).waitFor();
    await page.getByRole('button', { name: '发送', exact: true }).click();
    await page.getByText('失败后重试', { exact: true }).waitFor();
    assert.equal(submittedIds.at(-1), submittedIds.at(-2));
    direct.push({ messageId: 'peer-reply', conversationId: 'chat-1', conversationSeq: direct.length + 1, senderUserId: 'peer-1', messageType: 'text', body: { text: '实时回复' }, sentAt: '2026-10-27T09:06:00Z' });
    socket.send(JSON.stringify({ type: 1, target: 'msg.new', arguments: [{ data: { conversationId: 'chat-1' } }] }) + '\x1e');
    await page.getByText('实时回复', { exact: true }).waitFor();
    await page.getByRole('textbox', { name: '消息内容' }).fill('撤回时保留的草稿');
    direct[0].isRecalled = true;
    socket.send(JSON.stringify({ type: 1, target: 'msg.recalled', arguments: [{ data: { conversationId: 'chat-1' } }] }) + '\x1e');
    await page.getByText('[消息已撤回]', { exact: true }).waitFor();
    assert.equal(await page.getByRole('textbox', { name: '消息内容' }).inputValue(), '撤回时保留的草稿');
    assert.equal(await page.getByText('<img src=x onerror="window.fixtureXss=true">', { exact: true }).count(), 0);
    await page.getByRole('button', { name: '返回', exact: true }).click();
    await page.getByRole('button', { name: /项目讨论，/ }).click();
    await page.getByText('群聊历史', { exact: true }).waitFor();
    await page.getByRole('textbox', { name: '消息内容' }).fill('群聊发送');
    await page.getByRole('button', { name: '发送', exact: true }).click();
    await page.getByText('群聊发送', { exact: true }).waitFor();
    const previousConnects = connects;
    socket.close({ code: 1012, reason: 'Fixture reconnect' });
    await expect.poll(() => connects, { timeout: 10000 }).toBeGreaterThan(previousConnects);
    await page.getByText('已连接', { exact: true }).waitFor();
    await page.screenshot({ path: resolve(evidence, `chat-${viewport.width}.png`), fullPage: true });
    await page.getByRole('button', { name: '关闭', exact: true }).click();
    assert.equal(await page.getByRole('textbox', { name: '消息内容' }).count(), 0);
    await page.getByRole('button', { name: '重新打开', exact: true }).click();
    await page.getByRole('button', { name: /同事，/ }).waitFor();
    socket.send(JSON.stringify({ type: 1, target: 'auth.session.revoked', arguments: [{}] }) + '\x1e');
    await page.getByRole('button', { name: '登录', exact: true }).waitFor();
    assert.equal(await page.getByRole('button', { name: /同事，/ }).count(), 0);
    await page.getByRole('button', { name: '退出账号', exact: true }).click();
    await page.getByRole('button', { name: '登录', exact: true }).waitFor();
    assert.equal(await page.getByText('群聊发送', { exact: true }).count(), 0);
    await page.getByRole('button', { name: '释放 SDK', exact: true }).click();
    await page.evaluate(() => {
      window.testClient = new IMSDK.ImSdkClient();
      testClient.initialize({ apiBaseUrl: 'https://api.example.test', serviceRealmId: 'fixture', privacyConsentGranted: true, realtime: false });
      window.testView = IMSDK.mountMessenger(testClient, document.getElementById('messenger'));
    });
    await page.evaluate(() => testClient.authenticate({ userId: 'user-1', platformUserId: 'platform-1', spaceId: 'personal', accessToken: 'fixture-token', refreshToken: 'fixture-refresh', expiresAt: new Date(Date.now() + 3600000).toISOString() }));
    const queued = await page.evaluate(() => testView.openCustomerService({ serviceAccountId: 'brand-fixture' }));
    assert.equal(queued.canOpenConversation, false);
    await page.getByText('正在排队', { exact: true }).waitFor();
    assert.equal(await page.getByRole('textbox', { name: '消息内容' }).count(), 0);
    await page.evaluate(() => testClient.shutdown());
    assert.deepEqual(pageErrors, []);
    report.browsers.push({ engine: 'Chromium (installed Chrome)', version: browser.version(), viewport });
    report.checks.push({ viewport: viewport.width, passed: ['example configuration', 'password login', 'SignalR handshake', 'conversation list', 'contact selection starts direct chat', 'direct text send', 'XSS text rendering', 'stable send retry ID', 'realtime REST refresh', 'recall hides original', 'recall preserves draft', 'group text send', 'SignalR reconnect', 'close/reopen', 'security revocation clears UI', 'logout clears chat', 'queued service gate', 'shutdown', 'no unhandled errors'] });
    await context.close();
  }
  console.log('Browser contract checks passed at desktop 1280px and mobile 390px.');
} catch (error) {
  report.errors.push(error.stack || String(error));
  throw error;
} finally {
  await writeFile(resolve(evidence, 'browser-report.json'), JSON.stringify(report, null, 2));
  await browser.close();
  await new Promise(resolve => server.close(resolve));
}
