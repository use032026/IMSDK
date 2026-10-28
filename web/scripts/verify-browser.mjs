import { chromium, expect } from '@playwright/test';
import { createServer } from 'node:http';
import { readFile, mkdir, writeFile } from 'node:fs/promises';
import { resolve, sep } from 'node:path';
import assert from 'node:assert/strict';

// A browser contract fixture, never a substitute for a live backend acceptance run.
const evidence = resolve(process.env.IMSDK_BROWSER_EVIDENCE_DIR ?? '../logs/unification-web-20261028-browser');
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
    let passwordLogins = 0;
    let registrationAttempts = 0;
    let codeAttempts = 0;
    let captchaCount = 0;
    let friendSent = false;
    let acceptedFriend = false;
    let rejectedFriend = false;
    let groupCreated = false;
    let registeredPersonalSelections = 0;
    let assignedEnterprise = false;
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
      else if (path.endsWith('/verification/settings')) data = { smsEnabled: true, emailEnabled: true, smsRequired: true, emailRequired: true };
      else if (path.endsWith('/captcha/generate')) { captchaCount++; data = { token: `captcha-${captchaCount}`, question: '2 + 2 = ?' }; }
      else if (path.endsWith('/verification/send')) {
        codeAttempts++;
        if (codeAttempts === 1) { await route.fulfill({ status: 400, json: { code: 'AUTH_CAPTCHA_REQUIRED' } }); return; }
        assert.deepEqual(body, { identifier: 'alice@example.test', channel: 'email', purpose: 'register', captchaToken: 'captcha-1', captchaAnswer: '4' });
        data = { sent: true };
      }
      else if (path.endsWith('/auth/register')) {
        registrationAttempts++;
        assert.equal(body.tenantId, undefined);
        assert.equal(body.email, 'alice@example.test');
        assert.equal(body.loginType, 'email');
        if (registrationAttempts === 1) { await route.fulfill({ status: 400, json: { code: 'AUTH_CAPTCHA_REQUIRED' } }); return; }
        if (registrationAttempts === 2) {
          assert.equal(body.captchaToken, 'captcha-2');
          assert.equal(body.captchaAnswer, '4');
          data = { ...identity, platformToken: 'fixture-platform-token', tenants: [{ tenantId: 'must-not-select' }] };
        } else {
          assignedEnterprise = true;
          data = { ...identity, spaceContext: { spaceType: 2 }, tenantId: 'assigned-enterprise', accessToken: 'enterprise-token', refreshToken: 'enterprise-refresh', expiresIn: 3600 };
        }
      }
      else if (path.endsWith('/platform/v1/auth/login')) { passwordLogins++; data = { ...identity, platformToken: 'fixture-platform-token' }; }
      else if (path.endsWith('/select-personal-space')) { if (!passwordLogins) registeredPersonalSelections++; data = { ...identity, spaceContext: { spaceType: 1 }, accessToken: 'fixture-token', refreshToken: 'fixture-refresh', expiresIn: 3600 }; }
      else if (path.endsWith('/profile/me')) data = assignedEnterprise ? { ...identity, spaceContext: { spaceType: 2 }, tenantId: 'assigned-enterprise' } : identity;
      else if (path.endsWith('/conversations')) data = { items: conversations };
      else if (path.endsWith('/friends')) data = [{ friendUserId: 'peer-1', displayName: '同事' }, ...(acceptedFriend ? [{ friendUserId: 'peer-3', displayName: '新朋友' }] : [])];
      else if (path.endsWith('/search/users')) data = [{ userId: 'peer-2', displayName: '搜索好友', isFriend: false }];
      else if (path.endsWith('/friends/request')) { assert.equal(body.toUserId, 'peer-2'); friendSent = true; data = { requestId: 'sent-1', status: 'pending' }; }
      else if (path.endsWith('/friends/requests')) data = [
        { requestId: 'incoming-1', fromUserId: 'peer-3', fromDisplayName: '新朋友', toUserId: 'user-1', toDisplayName: '我', status: acceptedFriend ? 'accepted' : 'pending' },
        { requestId: 'incoming-2', fromUserId: 'peer-4', fromDisplayName: '另一位用户', toUserId: 'user-1', toDisplayName: '我', status: rejectedFriend ? 'rejected' : 'pending' },
      ];
      else if (path.endsWith('/friends/requests/incoming-1/handle')) { assert.equal(body.action, 'accept'); acceptedFriend = true; data = {}; }
      else if (path.endsWith('/friends/requests/incoming-2/handle')) { assert.equal(body.action, 'reject'); rejectedFriend = true; data = {}; }
      else if (path.endsWith('/groups/')) {
        assert.deepEqual(body, { title: '新建测试群', memberUserIds: ['peer-3'] });
        groupCreated = true;
        conversations.push({ conversationId: 'new-group', conversationType: 'group', title: '新建测试群', unreadCount: 0 });
        data = { groupId: 'new-group' };
      }
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
        } else data = path.includes('/new-group/') ? [] : messages;
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
    await page.addInitScript(() => {
      window.IMSDK_HOST_CONFIG = { apiBaseUrl: 'https://api.example.test', serviceRealmId: 'fixture-realm', privacyConsentGranted: true, passwordLogin: { space: 'personal', loginType: 'lpp_id' } };
    });
    await page.goto(url);
    assert.equal(await page.getByLabel('IM API 服务地址', { exact: true }).count(), 0);
    await page.getByRole('button', { name: '注册新账号', exact: true }).click();
    await page.getByLabel('注册方式', { exact: true }).selectOption('email');
    await page.getByPlaceholder('昵称', { exact: true }).fill('Alice');
    await page.getByPlaceholder('邮箱', { exact: true }).fill('alice@example.test');
    await page.getByPlaceholder('设置密码', { exact: true }).fill('fixture-password');
    await page.getByPlaceholder('确认密码', { exact: true }).fill('fixture-password');
    await page.getByRole('button', { name: '发送验证码', exact: true }).click();
    await page.getByPlaceholder('安全验证答案', { exact: true }).fill('4');
    await page.getByRole('button', { name: '发送验证码', exact: true }).click();
    await page.getByRole('alert').filter({ hasText: '验证码已发送' }).waitFor();
    await page.getByPlaceholder('注册验证码', { exact: true }).fill('123456');
    await page.getByRole('button', { name: '注册并登录', exact: true }).click();
    await page.getByPlaceholder('安全验证答案', { exact: true }).fill('4');
    await page.screenshot({ path: resolve(evidence, `registration-${viewport.width}.png`), fullPage: true });
    await page.getByRole('button', { name: '注册并登录', exact: true }).click();
    await page.getByRole('button', { name: /同事，/ }).waitFor();
    assert.equal(registeredPersonalSelections, 1);
    assert.equal(registrationAttempts, 2);
    await page.getByRole('button', { name: '退出登录', exact: true }).click();
    await page.getByPlaceholder('账号', { exact: true }).fill('fixture-user');
    await page.getByPlaceholder('密码', { exact: true }).fill('fixture-password');
    await page.getByRole('button', { name: '登录', exact: true }).click();
    await page.getByRole('button', { name: /同事，/ }).waitFor();
    await page.getByText('已连接', { exact: true }).waitFor();
    const loggedInConnects = connects;
    // This checks the lifecycle event contract. Native Safari cache restoration
    // is verified separately; synthetic events do not constitute that evidence.
    const loginsBeforeRestore = passwordLogins;
    await page.evaluate(() => {
      window.dispatchEvent(new PageTransitionEvent('pagehide', { persisted: true }));
      window.dispatchEvent(new PageTransitionEvent('pageshow', { persisted: true }));
    });
    await page.getByRole('button', { name: /同事，/ }).waitFor();
    assert.equal(await page.evaluate(() => IMSDK_HOST.client.isAuthenticated), true);
    assert.equal(await page.getByPlaceholder('账号', { exact: true }).count(), 0);
    assert.equal(passwordLogins, loginsBeforeRestore);
    assert.equal(connects, loggedInConnects);
    await page.getByRole('button', { name: '添加好友', exact: true }).click();
    await page.getByPlaceholder('搜索账号、手机号或邮箱', { exact: true }).fill('搜索好友');
    await page.getByRole('button', { name: '搜索用户', exact: true }).click();
    await page.getByRole('button', { name: '添加好友', exact: true }).click();
    await page.getByRole('button', { name: '已申请', exact: true }).waitFor();
    assert.equal(friendSent, true);
    await page.getByRole('button', { name: '查看好友申请', exact: true }).click();
    await page.getByRole('button', { name: '同意', exact: true }).first().click();
    await page.getByText('已成为好友', { exact: true }).waitFor();
    await page.getByRole('button', { name: '拒绝', exact: true }).click();
    await page.getByText('已拒绝', { exact: true }).waitFor();
    assert.equal(acceptedFriend, true);
    assert.equal(rejectedFriend, true);
    await page.getByRole('button', { name: '返回', exact: true }).click();
    await page.getByRole('button', { name: '发起单聊', exact: true }).click();
    await page.getByRole('button', { name: '与新朋友聊天', exact: true }).waitFor();
    await page.getByRole('button', { name: '新建群聊', exact: true }).click();
    await page.getByPlaceholder('群名称', { exact: true }).fill('新建测试群');
    await page.getByRole('checkbox', { name: '邀请新朋友', exact: true }).check();
    await page.screenshot({ path: resolve(evidence, `group-creation-${viewport.width}.png`), fullPage: true });
    await page.getByRole('button', { name: '创建群聊', exact: true }).click();
    await page.getByRole('textbox', { name: '消息内容' }).waitFor();
    assert.equal(groupCreated, true);
    await page.getByRole('button', { name: '返回', exact: true }).click();
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
    const sendsBeforeShortcut = submittedIds.length;
    const messageInput = page.getByRole('textbox', { name: '消息内容' });
    await messageInput.fill('旧 Safari 快捷发送');
    await messageInput.evaluate(element => Object.defineProperty(element.form, 'requestSubmit', { value: undefined, configurable: true }));
    await messageInput.press('Control+Enter');
    await page.getByText('旧 Safari 快捷发送', { exact: true }).waitFor();
    assert.equal(submittedIds.length, sendsBeforeShortcut + 1);
    assert.equal(direct.filter(message => message.body.text === '旧 Safari 快捷发送').length, 1);
    await messageInput.evaluate(element => { delete element.form.requestSubmit; });
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
    const sendsBeforeCacheEvents = submittedIds.length;
    await page.evaluate(() => {
      window.dispatchEvent(new PageTransitionEvent('pagehide', { persisted: true }));
      window.dispatchEvent(new PageTransitionEvent('pageshow', { persisted: true }));
    });
    await expect(page.getByRole('textbox', { name: '消息内容' })).toHaveValue('撤回时保留的草稿');
    assert.equal(submittedIds.length, sendsBeforeCacheEvents);
    assert.equal(passwordLogins, loginsBeforeRestore);
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
    await page.getByRole('button', { name: '打开聊天', exact: true }).click();
    await page.getByRole('button', { name: /同事，/ }).waitFor();
    socket.send(JSON.stringify({ type: 1, target: 'auth.session.revoked', arguments: [{}] }) + '\x1e');
    await page.getByRole('button', { name: '登录', exact: true }).waitFor();
    assert.equal(await page.getByRole('button', { name: /同事，/ }).count(), 0);
    await page.evaluate(() => IMSDK_HOST.client.logout());
    await page.getByRole('button', { name: '登录', exact: true }).waitFor();
    assert.equal(await page.getByText('群聊发送', { exact: true }).count(), 0);
    await page.evaluate(() => IMSDK_HOST.client.shutdown());
    await page.evaluate(() => {
      window.testClient = new IMSDK.ImSdkClient();
      testClient.initialize({ apiBaseUrl: 'https://api.example.test', serviceRealmId: 'fixture', privacyConsentGranted: true, realtime: false });
      document.getElementById('messenger').hidden = false;
      document.getElementById('closed-panel').hidden = true;
      window.testView = IMSDK.mountMessenger(testClient, document.getElementById('messenger'));
    });
    await page.evaluate(() => testClient.authenticate({ userId: 'user-1', platformUserId: 'platform-1', spaceId: 'personal', accessToken: 'fixture-token', refreshToken: 'fixture-refresh', expiresAt: new Date(Date.now() + 3600000).toISOString() }));
    const queued = await page.evaluate(() => testView.openCustomerService({ serviceAccountId: 'brand-fixture' }));
    assert.equal(queued.canOpenConversation, false);
    await page.getByText('正在排队', { exact: true }).waitFor();
    assert.equal(await page.getByRole('textbox', { name: '消息内容' }).count(), 0);
    await page.evaluate(() => testClient.shutdown());
    await page.evaluate(() => {
      window.testClient = new IMSDK.ImSdkClient();
      testClient.initialize({ apiBaseUrl: 'https://api.example.test', serviceRealmId: 'fixture', privacyConsentGranted: true, realtime: false });
      document.getElementById('messenger').hidden = false;
      document.getElementById('closed-panel').hidden = true;
      window.testView = IMSDK.mountMessenger(testClient, document.getElementById('messenger'));
    });
    await page.getByRole('button', { name: '注册新账号', exact: true }).click();
    await page.getByText('注册后即可开始聊天，无需选择空间。', { exact: true }).waitFor();
    await page.getByLabel('注册方式', { exact: true }).selectOption('email');
    await page.getByPlaceholder('昵称', { exact: true }).fill('Alice');
    await page.getByPlaceholder('邮箱', { exact: true }).fill('alice@example.test');
    await page.getByPlaceholder('设置密码', { exact: true }).fill('fixture-password');
    await page.getByPlaceholder('确认密码', { exact: true }).fill('fixture-password');
    await page.getByPlaceholder('注册验证码', { exact: true }).fill('123456');
    await page.getByRole('button', { name: '注册并登录', exact: true }).click();
    await page.getByRole('button', { name: /同事，/ }).waitFor();
    assert.deepEqual(await page.evaluate(() => testClient.currentUser), { ...identity, spaceId: 'assigned-enterprise' });
    assert.equal(registeredPersonalSelections, 1);
    await page.screenshot({ path: resolve(evidence, `enterprise-registration-${viewport.width}.png`), fullPage: true });
    await page.evaluate(() => testClient.logout());
    assert.equal(await page.evaluate(() => testClient.currentUser), undefined);
    await page.evaluate(() => testClient.shutdown());
    assert.deepEqual(pageErrors, []);
    report.browsers.push({ engine: 'Chromium (installed Chrome)', version: browser.version(), viewport });
    report.checks.push({ viewport: viewport.width, passed: ['example configuration', 'registration verification and captcha', 'registration default personal login', 'direct enterprise registration preserves actual assigned space without chooser', 'single active session cleared on logout', 'friend search and pending request', 'accept/reject friend requests', 'accepted friend available in contacts', 'create group with selected friend', 'password login', 'SignalR handshake', 'bfcache lifecycle events preserve account', 'bfcache lifecycle events preserve draft without sending', 'conversation list', 'contact selection starts direct chat', 'direct text send', 'legacy requestSubmit shortcut fallback', 'XSS text rendering', 'stable send retry ID', 'realtime REST refresh', 'recall hides original', 'recall preserves draft', 'group text send', 'SignalR reconnect', 'close/reopen', 'security revocation clears UI', 'logout clears chat', 'queued service gate', 'shutdown', 'no unhandled errors'] });
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
