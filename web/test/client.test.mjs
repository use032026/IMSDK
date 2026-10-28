import assert from 'node:assert/strict';
import { test } from 'node:test';
import { ImSdkClient, ImSdkError } from '../dist/index.js';

const baseConfig = {
  apiBaseUrl: 'https://api.example.test',
  serviceRealmId: 'web-test',
  privacyConsentGranted: true,
  realtime: false,
};
const credentials = (overrides = {}) => ({
  platformUserId: 'platform-1', userId: 'user-1', spaceId: 'personal',
  accessToken: 'access-1', refreshToken: 'refresh-1',
  expiresAt: new Date(Date.now() + 3_600_000).toISOString(), ...overrides,
});
const identity = { userId: 'user-1', platformUserId: 'platform-1' };
const target = { conversationId: 'chat-1', type: 'direct', title: '单聊' };
const authResult = (overrides = {}) => ({
  ...identity, tenantId: 'tenant-1', accessToken: 'access-1', refreshToken: 'refresh-1',
  expiresIn: 3600, ...overrides,
});
const ok = (data) => new Response(JSON.stringify({ code: 'OK', data }), {
  status: 200, headers: { 'Content-Type': 'application/json' },
});
const rejected = (status, code = 'UNAUTHORIZED') => new Response(JSON.stringify({ code, message: 'rejected' }), {
  status, headers: { 'Content-Type': 'application/json' },
});
async function harness(t, handler, configuration = {}) {
  const previousFetch = globalThis.fetch;
  const requests = [];
  const clients = [];
  globalThis.fetch = async (input, init = {}) => {
    const url = new URL(typeof input === 'string' || input instanceof URL ? input : input.url);
    const request = {
      url, path: url.pathname, method: init.method || 'GET', headers: new Headers(init.headers),
      body: typeof init.body === 'string' ? JSON.parse(init.body) : init.body, signal: init.signal,
    };
    requests.push(request);
    const response = await handler(request, requests);
    if (response !== undefined) return response;
    if (request.path === '/api/client/v1/profile/me') return ok(identity);
    throw new Error(`Unexpected request: ${request.method} ${request.path}`);
  };
  const createClient = (config = {}) => {
    const client = new ImSdkClient();
    client.initialize({ ...baseConfig, ...configuration, ...config });
    clients.push(client);
    return client;
  };
  t.after(async () => {
    for (const client of clients) await client.shutdown();
    globalThis.fetch = previousFetch;
  });
  return { client: createClient(), createClient, requests };
}

test('contacts use server friend identities and display remarks without accepting arbitrary targets', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/friends') return ok([{ userId: 'self-ignored', friendUserId: 'peer-1', displayName: 'Name', remarkName: '同事' }]);
  });
  await client.authenticate(credentials());
  assert.deepEqual(await client.listContacts(), [{ userId: 'peer-1', displayName: '同事' }]);
});

test('configuration requires consent and HTTPS service endpoints', () => {
  for (const patch of [
    { privacyConsentGranted: false },
    { apiBaseUrl: 'http://api.example.test' },
    { apiBaseUrl: 'https://user:secret@api.example.test' },
    { gatewayBaseUrl: 'ws://gateway.example.test' },
    { serviceRealmId: '' },
  ]) {
    assert.throws(() => new ImSdkClient().initialize({ ...baseConfig, ...patch }), ImSdkError);
  }
});

test('external authentication validates the bearer against profile/me', async (t) => {
  const { client, requests } = await harness(t, () => undefined);
  await client.authenticate(credentials());
  assert.equal(client.isAuthenticated, true);
  assert.deepEqual(client.currentUser, { ...identity, spaceId: 'personal' });
  assert.equal(requests[0].path, '/api/client/v1/profile/me');
  assert.equal(requests[0].headers.get('Authorization'), 'Bearer access-1');
});

test('external credentials cannot replace the identity accepted by the server', async (t) => {
  const { client } = await harness(t, () => undefined);
  await assert.rejects(client.authenticate(credentials({ userId: 'another-user' })), ImSdkError);
  assert.equal(client.isAuthenticated, false);
  assert.equal(client.currentUser, undefined);
});

test('expired external credentials are rejected before network authentication', async (t) => {
  const { client, requests } = await harness(t, () => undefined);
  await assert.rejects(client.authenticate(credentials({ expiresAt: '2000-01-01T00:00:00Z' })), ImSdkError);
  assert.equal(requests.length, 0);
  assert.equal(client.isAuthenticated, false);
});

test('personal password login selects personal space without querying enterprises', async (t) => {
  const { client, requests } = await harness(t, (request) => {
    if (request.path === '/api/platform/v1/auth/login') {
      assert.equal(request.body.identifier, 'alice');
      assert.equal(request.body.password, 'test-password');
      assert.equal(request.body.loginType, 'lpp_id');
      return ok({ platformUserId: 'platform-1', platformToken: 'platform-token' });
    }
    if (request.path === '/api/platform/v1/auth/select-personal-space') {
      assert.equal(request.headers.get('Authorization'), 'Bearer platform-token');
      return ok(authResult({ spaceContext: { spaceType: 1 }, tenantId: undefined }));
    }
  }, { passwordLogin: { space: 'personal', loginType: 'lpp_id' } });
  await client.loginWithPassword({ account: 'alice', password: 'test-password' });
  assert.equal(client.currentUser.spaceId, 'personal');
  assert.equal(requests.some((request) => request.path === '/api/platform/v1/my/tenants'), false);
});

test('tenant login_name uses the configured tenant and web device type', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/auth/login') {
      assert.deepEqual(request.body, {
        loginName: 'employee', password: 'test-password', loginType: 'login_name',
        deviceType: 'web', tenantCode: 'ACME', captchaToken: 'challenge', captchaAnswer: '8',
      });
      return ok(authResult());
    }
  }, { passwordLogin: { space: 'tenant', loginType: 'login_name', tenantCode: 'ACME' } });
  await client.loginWithPassword({ account: 'employee', password: 'test-password', captchaToken: 'challenge', captchaAnswer: '8' });
  assert.equal(client.currentUser.spaceId, 'tenant-1');
});

test('tenant lpp_id login selects the exact configured tenant', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/platform/v1/auth/login') return ok({ ...identity, platformToken: 'platform-token' });
    if (request.path === '/api/platform/v1/my/tenants') return ok([
      { tenantId: 'wrong-tenant', tenantCode: 'ACME-OTHER' },
      { tenantId: 'tenant-1', tenantCode: 'ACME' },
    ]);
    if (request.path === '/api/platform/v1/auth/select-tenant') {
      assert.deepEqual(request.body, { tenantId: 'tenant-1' });
      assert.equal(request.headers.get('Authorization'), 'Bearer platform-token');
      return ok(authResult());
    }
  }, { passwordLogin: { space: 'tenant', loginType: 'lpp_id', tenantCode: 'ACME' } });
  await client.loginWithPassword({ account: 'alice', password: 'test-password' });
  assert.equal(client.currentUser.spaceId, 'tenant-1');
});

test('captcha requests expose challenge fields and omit authentication', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/auth/captcha/generate') {
      assert.equal(request.method, 'POST');
      assert.equal(request.headers.has('Authorization'), false);
      return ok({ token: 'challenge-token', captchaQuestion: '2 + 3 = ?' });
    }
  }, { passwordLogin: { space: 'personal', loginType: 'lpp_id' } });
  assert.deepEqual(await client.requestLoginCaptcha(), { token: 'challenge-token', question: '2 + 3 = ?' });
});

test('a 401 refreshes the credential pair and retries the request once', async (t) => {
  let attempts = 0;
  let refreshes = 0;
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/conversations') {
      attempts++;
      if (attempts === 1) return rejected(401);
      assert.equal(request.headers.get('Authorization'), 'Bearer access-new');
      return ok({ items: [] });
    }
    if (request.path === '/api/client/v1/auth/refresh') {
      refreshes++;
      assert.equal(request.body.refreshToken, 'refresh-1');
      return ok({ accessToken: 'access-new', refreshToken: 'refresh-new', expiresIn: 3600 });
    }
  });
  await client.authenticate(credentials());
  await client.listConversations();
  assert.equal(attempts, 2);
  assert.equal(refreshes, 1);
  assert.equal(client.isAuthenticated, true);
});

test('simultaneous 401 responses share one refresh request', async (t) => {
  let refreshes = 0;
  let finishRefresh;
  const refreshResponse = new Promise((resolve) => { finishRefresh = resolve; });
  let reportRefresh;
  const refreshStarted = new Promise((resolve) => { reportRefresh = resolve; });
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/conversations') {
      return request.headers.get('Authorization') === 'Bearer access-1' ? rejected(401) : ok({ items: [] });
    }
    if (request.path === '/api/client/v1/auth/refresh') {
      refreshes++;
      reportRefresh();
      return refreshResponse;
    }
  });
  await client.authenticate(credentials());
  const first = client.listConversations();
  const second = client.listConversations();
  await refreshStarted;
  // Permit both initial 401 handlers to join the pending refresh.
  await new Promise((resolve) => setImmediate(resolve));
  finishRefresh(ok({ accessToken: 'access-new', refreshToken: 'refresh-new', expiresIn: 3600 }));
  await Promise.all([first, second]);
  assert.equal(refreshes, 1);
});

test('network failure during refresh retains the authenticated account', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/conversations') return rejected(401);
    if (request.path === '/api/client/v1/auth/refresh') throw new TypeError('network unavailable');
  });
  await client.authenticate(credentials());
  await assert.rejects(client.listConversations(), ImSdkError);
  assert.equal(client.isAuthenticated, true);
  assert.equal(client.currentUser.userId, 'user-1');
});

test('a second 401 does not create a refresh loop', async (t) => {
  let attempts = 0;
  let refreshes = 0;
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/conversations') { attempts++; return rejected(401); }
    if (request.path === '/api/client/v1/auth/refresh') {
      refreshes++;
      return ok({ accessToken: 'access-new', refreshToken: 'refresh-new', expiresIn: 3600 });
    }
  });
  await client.authenticate(credentials());
  await assert.rejects(client.listConversations(), ImSdkError);
  assert.equal(attempts, 2);
  assert.equal(refreshes, 1);
});

test('logout invalidates requests started by the previous session', async (t) => {
  let finishRequest;
  let reportStarted;
  const started = new Promise((resolve) => { reportStarted = resolve; });
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/conversations') {
      reportStarted();
      return new Promise((resolve, reject) => {
        finishRequest = () => resolve(ok({ items: [] }));
        request.signal?.addEventListener('abort', () => reject(new DOMException('aborted', 'AbortError')), { once: true });
      });
    }
  });
  await client.authenticate(credentials());
  const pending = client.listConversations();
  const assertion = assert.rejects(pending, ImSdkError);
  await started;
  await client.logout();
  finishRequest();
  await assertion;
  assert.equal(client.isAuthenticated, false);
  assert.equal(client.currentUser, undefined);
});

test('SDK instances keep credentials and logout independent', async (t) => {
  const { client, createClient } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/profile/me') {
      return ok(request.headers.get('Authorization') === 'Bearer access-2'
        ? { userId: 'user-2', platformUserId: 'platform-2' } : identity);
    }
    if (request.path === '/api/client/v1/conversations') {
      assert.equal(request.headers.get('Authorization'), 'Bearer access-2');
      return ok({ items: [] });
    }
  });
  const second = createClient();
  await client.authenticate(credentials());
  await second.authenticate(credentials({ userId: 'user-2', platformUserId: 'platform-2', accessToken: 'access-2' }));
  await client.logout();
  await second.listConversations();
  assert.equal(second.isAuthenticated, true);
  assert.equal(second.currentUser.userId, 'user-2');
});

test('conversation pagination preserves cursor and maps direct/group records', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/conversations') {
      assert.equal(request.url.searchParams.get('cursor'), 'page 2/+');
      assert.equal(request.url.searchParams.get('limit'), '20');
      return ok({ items: [
        { conversationId: 'chat-1', conversationType: 'direct', title: 'Alice', unreadCount: 2 },
        { conversationId: 'group-1', conversationType: 'group', title: 'Team', unreadCount: 0 },
      ], nextCursor: 'next-page' });
    }
  });
  await client.authenticate(credentials());
  const page = await client.listConversations({ cursor: 'page 2/+', limit: 20 });
  assert.equal(page.nextCursor, 'next-page');
  assert.deepEqual(page.items.map((item) => [item.conversationId, item.type, item.title, item.unreadCount]), [
    ['chat-1', 'direct', 'Alice', 2], ['group-1', 'group', 'Team', 0],
  ]);
});

test('direct and group history use their corresponding routes and sequence cursor', async (t) => {
  const paths = [];
  const { client } = await harness(t, (request) => {
    if (request.path.endsWith('/messages')) {
      paths.push(request.path);
      assert.equal(request.url.searchParams.get('beforeSeq'), '25');
      assert.equal(request.url.searchParams.get('limit'), '10');
      return ok([{ messageId: 'm-1', conversationId: request.path.includes('/groups/') ? 'group-1' : 'chat-1',
        senderUserId: 'user-1', messageType: 'text', body: { text: 'hello' }, conversationSeq: 24, sentAt: '2026-01-01T00:00:00Z' }]);
    }
  });
  await client.authenticate(credentials());
  const direct = await client.listMessages(target, { beforeSeq: 25, limit: 10 });
  const group = await client.listMessages({ conversationId: 'group-1', type: 'group' }, { beforeSeq: 25, limit: 10 });
  assert.deepEqual(paths, ['/api/client/v1/direct-chats/chat-1/messages', '/api/client/v1/groups/group-1/messages']);
  assert.equal(direct[0].text, 'hello');
  assert.equal(direct[0].isSelf, true);
  assert.equal(group[0].seq, 24);
});

test('text sends include unique clientMsgId and reconstruct the compact server response', async (t) => {
  const submitted = [];
  const { client } = await harness(t, (request) => {
    if (request.path.endsWith('/messages')) {
      assert.equal(request.method, 'POST');
      assert.equal(request.body.messageType, 'text');
      assert.equal(request.body.body.text, 'hello');
      assert.ok(request.body.clientMsgId);
      submitted.push(request.body.clientMsgId);
      return ok({ messageId: `m-${submitted.length}`, conversationSeq: submitted.length, serverTime: '2026-01-01T00:00:00Z' });
    }
  });
  await client.authenticate(credentials());
  const sent = await client.sendText(target, 'hello');
  await client.sendText({ conversationId: 'group-1', type: 'group' }, 'hello');
  assert.notEqual(submitted[0], submitted[1]);
  assert.equal(sent.conversationId, 'chat-1');
  assert.equal(sent.text, 'hello');
  assert.equal(sent.senderUserId, 'user-1');
  assert.equal(sent.isSelf, true);
});

test('failed non-idempotent message requests are not retried after network loss', async (t) => {
  let submissions = 0;
  const { client } = await harness(t, (request) => {
    if (request.path.endsWith('/messages')) { submissions++; throw new TypeError('connection lost after submission'); }
  });
  await client.authenticate(credentials());
  await assert.rejects(client.sendText(target, 'hello'), ImSdkError);
  assert.equal(submissions, 1);
});

test('brand customer-service uses threadStatus and queued never opens a chat', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/customer-service/im-direct/contact-brand') {
      assert.deepEqual(request.body, { serviceAccountId: 'brand-1', priority: 0, locale: 'zh_CN', category: 'sales' });
      return ok({ threadId: 'thread-1', threadStatus: 'pending', conversationId: 'not-ready-chat', status: 'active' });
    }
  });
  await client.authenticate(credentials());
  const session = await client.requestCustomerService({ serviceAccountId: 'brand-1', locale: 'zh_CN', category: 'sales' });
  assert.equal(session.threadId, 'thread-1');
  assert.equal(session.status, 'queued');
  assert.equal(session.canOpenConversation, false);
});

test('current-tenant customer-service uses status and requires a real conversation for active state', async (t) => {
  let contacts = 0;
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/official-account/contact-service') {
      contacts++;
      return ok({ threadId: 'thread-1', status: 'active', threadStatus: 'queued',
        ...(contacts === 1 ? {} : { conversationId: 'service-chat-1' }) });
    }
  });
  await client.authenticate(credentials({ spaceId: 'tenant-1' }));
  const preparing = await client.requestCustomerService({ entry: 'currentTenant' });
  assert.equal(preparing.status, 'active');
  assert.equal(preparing.canOpenConversation, false);
  const ready = await client.requestCustomerService({ entry: 'currentTenant' });
  assert.equal(ready.conversationId, 'service-chat-1');
  assert.equal(ready.canOpenConversation, true);
});

test('text messages preserve spaces and line breaks in history and send results', async (t) => {
  const text = '  first line\n\n  second line  \n';
  const { client } = await harness(t, (request) => {
    if (request.path.endsWith('/messages') && request.method === 'GET') {
      return ok([{ messageId: 'history-1', senderUserId: 'user-1', messageType: 'text', body: { text }, conversationSeq: 1 }]);
    }
    if (request.path.endsWith('/messages') && request.method === 'POST') {
      assert.equal(request.body.body.text, text);
      return ok({ messageId: 'sent-1', conversationSeq: 2, serverTime: '2026-01-01T00:00:00Z' });
    }
  });
  await client.authenticate(credentials());
  assert.equal((await client.listMessages(target))[0].text, text);
  assert.equal((await client.sendText(target, text)).text, text);
});

test('recalled messages hide their original text for both supported recall markers', async (t) => {
  const privateText = 'recalled-content-must-not-be-visible';
  const { client } = await harness(t, (request) => {
    if (request.path.endsWith('/messages')) return ok([
      { messageId: 'm-1', messageType: 'text', isRecalled: true, body: { text: privateText }, conversationSeq: 1 },
      { messageId: 'm-2', messageType: 'text', status: 'recalled', body: JSON.stringify({ text: privateText }), conversationSeq: 2 },
    ]);
  });
  await client.authenticate(credentials());
  const messages = await client.listMessages(target);
  assert.equal(messages.length, 2);
  for (const message of messages) {
    assert.equal(message.type, 'recalled');
    assert.equal(message.text.includes(privateText), false);
    assert.match(message.text, /撤回/);
  }
});

test('identity changes clear the prior account and notify while verification is still pending', async (t) => {
  let finishVerification;
  let reportStarted;
  const started = new Promise((resolve) => { reportStarted = resolve; });
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/profile/me' && request.headers.get('Authorization') === 'Bearer access-2') {
      reportStarted();
      return new Promise((resolve) => { finishVerification = resolve; });
    }
  });
  await client.authenticate(credentials());
  const transitions = [];
  client.on((event) => {
    if (event.type === 'sessionChanging') transitions.push({ user: client.currentUser, authenticated: client.isAuthenticated });
  });
  const changing = client.authenticate(credentials({ userId: 'user-2', platformUserId: 'platform-2', accessToken: 'access-2' }));
  const rejectedChange = assert.rejects(changing, ImSdkError);
  await started;
  assert.deepEqual(transitions, [{ user: undefined, authenticated: false }]);
  assert.equal(client.currentUser, undefined);
  assert.equal(client.isAuthenticated, false);
  // An accepted bearer for a different identity must not restore either account.
  finishVerification(ok({ userId: 'unexpected-user', platformUserId: 'unexpected-platform' }));
  await rejectedChange;
  assert.equal(client.currentUser, undefined);
  assert.equal(client.isAuthenticated, false);
});

test('refresh rejects a credential pair for another identity and retires the account', async (t) => {
  let attempts = 0;
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/conversations') { attempts++; return rejected(401); }
    if (request.path === '/api/client/v1/auth/refresh') return ok({
      accessToken: 'foreign-access', refreshToken: 'foreign-refresh', expiresIn: 3600,
      userId: 'foreign-user', platformUserId: 'foreign-platform',
    });
  });
  await client.authenticate(credentials());
  await assert.rejects(client.listConversations(), (error) => error instanceof ImSdkError && error.code === 'AUTH_EXTERNAL_IDENTITY_MISMATCH');
  assert.equal(attempts, 1);
  assert.equal(client.currentUser, undefined);
  assert.equal(client.isAuthenticated, false);
});

test('request timeout has a stable public error and does not expose transport payloads', async (t) => {
  const privatePayload = 'transport-secret-access-1-refresh-1';
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/conversations') {
      return new Promise((_resolve, reject) => {
        request.signal.addEventListener('abort', () => reject(new Error(privatePayload)), { once: true });
      });
    }
  }, { requestTimeoutMs: 100 });
  await client.authenticate(credentials());
  await assert.rejects(client.listConversations(), (error) => {
    assert.ok(error instanceof ImSdkError);
    assert.equal(error.code, 'REQUEST_TIMEOUT');
    assert.equal(error.message, '请求超时，请重试');
    const exposed = `${error}\n${JSON.stringify(error)}`;
    assert.equal(exposed.includes(privatePayload), false);
    assert.equal(exposed.includes('access-1'), false);
    assert.equal(exposed.includes('refresh-1'), false);
    return true;
  });
  assert.equal(client.isAuthenticated, true);
});
