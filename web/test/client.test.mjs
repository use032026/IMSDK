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

const registrationSettings = { smsEnabled: true, emailEnabled: true, smsRequired: true, emailRequired: true };
const registration = (overrides = {}) => ({ channel: 'email', identifier: 'alice@example.test', displayName: 'Alice',
  password: 'fixture-password', verificationCode: '123456', ...overrides });

test('registration follows server verification settings, sends register codes and preserves captcha', async t => {
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/verification/send')) return ok({ sent: true });
  });
  assert.deepEqual(await client.getRegistrationVerificationSettings(), registrationSettings);
  await client.sendRegistrationCode({ channel: 'sms', identifier: '13800000001', captchaToken: 'captcha', captchaAnswer: '4' });
  assert.deepEqual(requests.at(-1).body, { channel: 'sms', identifier: '13800000001', purpose: 'register', captchaToken: 'captcha', captchaAnswer: '4' });
});

test('registration never chooses a tenant and auto-authenticates personal even under a fixed enterprise config', async t => {
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) {
      assert.deepEqual(request.body, { displayName: 'Alice', password: 'fixture-password', loginType: 'email', email: 'alice@example.test', verificationCode: '123456' });
      return ok({ platformToken: 'new-platform-token', platformRefreshToken: 'new-refresh', platformUserId: 'platform-1', tenants: [{ tenantId: 'tenant-1' }] });
    }
    if (request.path.endsWith('/select-personal-space')) {
      assert.equal(request.headers.get('Authorization'), 'Bearer new-platform-token');
      return ok(authResult({ spaceContext: { spaceType: 1 } }));
    }
  }, { passwordLogin: { space: 'tenant', loginType: 'login_name', tenantCode: 'fixed' } });
  await client.registerWithPassword(registration());
  assert.equal(client.isAuthenticated, true);
  assert.equal(client.currentUser.spaceId, 'personal');
  assert.equal(requests.some(r => /my\/tenants|select-tenant/.test(r.path)), false);
});

test('registration accepts a verified direct personal result without additional space selection', async t => {
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok(authResult({ spaceContext: { spaceType: 1 } }));
  });
  await client.registerWithPassword(registration());
  assert.equal(client.currentUser.spaceId, 'personal');
  assert.equal(requests.some(r => r.path.endsWith('/select-personal-space')), false);
});

test('direct enterprise registration uses its actual space and replaces the single active session', async t => {
  let assignedType = 2;
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok(authResult({ tenantId: assignedType === 2 ? 'assigned-enterprise' : undefined, spaceContext: { spaceType: assignedType } }));
    if (request.path.endsWith('/profile/me')) return ok({ ...identity, ...(assignedType === 2 ? { tenantId: 'assigned-enterprise' } : {}), spaceContext: { spaceType: assignedType } });
  });
  assignedType = 1;
  await client.authenticate(credentials());
  const previousRevision = client.sessionRevision;
  const transitions = [];
  const unsubscribe = client.on(event => {
    if (event.type === 'sessionChanging') transitions.push(client.currentUser);
  });
  assignedType = 2;
  await client.registerWithPassword(registration());
  assert.equal(client.isAuthenticated, true);
  assert.equal(client.currentUser.spaceId, 'assigned-enterprise');
  assert.equal(client.sessionRevision, previousRevision + 1);
  assignedType = 1;
  await client.registerWithPassword(registration());
  assert.equal(client.currentUser.spaceId, 'personal');
  assert.equal(client.sessionRevision, previousRevision + 2);
  assert.deepEqual(transitions, [undefined, undefined]);
  assert.equal(requests.some(request => /select-personal-space|my\/tenants|select-tenant/.test(request.path)), false);
  unsubscribe();
});

test('default personal selection preserves a resolved enterprise session returned by the backend', async t => {
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok({ platformToken: 'new-platform-token' });
    if (request.path.endsWith('/select-personal-space')) return ok(authResult({ tenantId: undefined, spaceContext: { spaceType: 2, tenantId: 'assigned-enterprise' } }));
    if (request.path.endsWith('/profile/me')) return ok({ ...identity, tenantId: 'assigned-enterprise', spaceContext: { spaceType: 2 } });
  });
  await client.registerWithPassword(registration());
  assert.equal(client.currentUser.spaceId, 'assigned-enterprise');
  assert.equal(requests.filter(request => request.path.endsWith('/select-personal-space')).length, 1);
  assert.equal(requests.some(request => /my\/tenants|select-tenant/.test(request.path)), false);
});

test('explicit enterprise type takes precedence over a legacy UUID personal compatibility marker', async t => {
  const tenantId = '11111111-1111-1111-1111-111111111111';
  const { client } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok(authResult({ tenantId, spaceContext: { spaceType: 2 } }));
    if (request.path.endsWith('/profile/me')) return ok({ ...identity, tenantId, spaceContext: { spaceType: 2 } });
  });
  await client.registerWithPassword(registration());
  assert.equal(client.isAuthenticated, true);
  assert.equal(client.currentUser.spaceId, tenantId);
});

test('enterprise registration rejects an explicit profile spaceId belonging to a different space', async t => {
  const { client } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok(authResult({ tenantId: undefined, spaceId: 'assigned-enterprise', spaceContext: { spaceType: 2 } }));
    if (request.path.endsWith('/profile/me')) return ok({ ...identity, spaceId: 'other-enterprise' });
  });
  await assert.rejects(client.registerWithPassword(registration()), { code: 'REGISTER_LOGIN_FAILED' });
  assert.equal(client.isAuthenticated, false);
});

test('registration requires a code only when its enabled channel requires one', async t => {
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok({ ...registrationSettings, emailRequired: false });
    if (request.path.endsWith('/auth/register')) return ok(authResult({ spaceContext: { spaceType: 1 } }));
  });
  await client.registerWithPassword(registration({ verificationCode: undefined }));
  assert.equal(Object.hasOwn(requests.find(r => r.path.endsWith('/auth/register')).body, 'verificationCode'), false);
});

test('disabled channels and missing required codes stop registration before creating an account', async t => {
  let disabled = true;
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok({ ...registrationSettings, emailEnabled: !disabled });
  });
  await assert.rejects(client.registerWithPassword(registration()), { code: 'REGISTER_CHANNEL_DISABLED' });
  disabled = false;
  await assert.rejects(client.registerWithPassword(registration({ verificationCode: undefined })), { code: 'AUTH_VERIFICATION_REQUIRED' });
  assert.equal(requests.some(r => r.path.endsWith('/auth/register')), false);
});

test('registration rejects unresolved space and contradictory enterprise markers', async t => {
  let data;
  const { client } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok(data);
  });
  for (const override of [
    { tenantId: undefined },
    { tenantId: 'tenant-1', spaceContext: { spaceType: 0 } },
    { tenantId: 'personal', spaceContext: { spaceType: 2 } },
  ]) {
    data = authResult(override);
    await assert.rejects(client.registerWithPassword(registration()), { code: 'REGISTER_LOGIN_FAILED' });
    assert.equal(client.isAuthenticated, false);
  }
});

test('registration distinguishes approval and created-account login failure', async t => {
  let pending = true;
  const { client } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok({ platformToken: 'new-token', pendingApproval: pending });
    if (request.path.endsWith('/select-personal-space')) return rejected(503, 'UNAVAILABLE');
  });
  await assert.rejects(client.registerWithPassword(registration()), { code: 'REGISTER_PENDING_APPROVAL' });
  pending = false;
  await assert.rejects(client.registerWithPassword(registration()), { code: 'REGISTER_LOGIN_FAILED' });
  assert.equal(client.isAuthenticated, false);
});

test('registration rejects unresolved selected-space results without space identifiers', async t => {
  let spaceType = 0;
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok({ platformToken: 'new-platform-token' });
    if (request.path.endsWith('/select-personal-space')) return ok(authResult({ tenantId: undefined, spaceContext: { spaceType } }));
  });
  for (spaceType of [0, 2]) {
    await assert.rejects(client.registerWithPassword(registration()), { code: 'REGISTER_LOGIN_FAILED' });
    assert.equal(client.isAuthenticated, false);
  }
  assert.equal(requests.some(request => request.path.endsWith('/profile/me')), false);
});

test('personal password login rejects explicitly nonpersonal selected-space results without identifiers', async t => {
  let spaceType = 0;
  const { client } = await harness(t, request => {
    if (request.path.endsWith('/auth/login')) return ok({ platformToken: 'platform-token' });
    if (request.path.endsWith('/select-personal-space')) return ok(authResult({ tenantId: undefined, spaceContext: { spaceType } }));
  });
  for (spaceType of [0, 2]) {
    await assert.rejects(client.loginWithPassword({ account: 'alice', password: 'fixture-password' }), { code: 'AUTH_CONTEXT_REQUIRED' });
    assert.equal(client.isAuthenticated, false);
  }
});

test('registration rejects profile space contradicting the returned authenticated session', async t => {
  const { client } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return ok(authResult({ spaceContext: { spaceType: 1 } }));
    if (request.path.endsWith('/profile/me')) return ok({ ...identity, spaceContext: { spaceType: 2 } });
  });
  await assert.rejects(client.registerWithPassword(registration()), { code: 'REGISTER_LOGIN_FAILED' });
  assert.equal(client.isAuthenticated, false);
});

test('registration captcha rejection preserves its actionable code without pretending an account exists', async t => {
  const { client } = await harness(t, request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) return rejected(400, 'AUTH_CAPTCHA_REQUIRED');
  });
  await assert.rejects(client.registerWithPassword(registration()), { code: 'AUTH_CAPTCHA_REQUIRED' });
  assert.equal(client.isAuthenticated, false);
});

test('logout during registration prevents stale registration and space responses from authenticating', async t => {
  let release;
  let registrationStarted;
  const started = new Promise(resolve => { registrationStarted = resolve; });
  const delayed = new Promise(resolve => { release = resolve; });
  const { client } = await harness(t, async request => {
    if (request.path.endsWith('/verification/settings')) return ok(registrationSettings);
    if (request.path.endsWith('/auth/register')) { registrationStarted(); await delayed; return ok({ platformToken: 'new-token' }); }
  });
  const pending = client.registerWithPassword(registration());
  await started;
  await client.logout();
  release();
  await assert.rejects(pending, { code: 'SESSION_CHANGED' });
  assert.equal(client.isAuthenticated, false);
});

test('personal password login recognizes the same mobile and email identities used to register', async t => {
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/auth/login')) return ok({ platformToken: 'platform-token', platformUserId: 'platform-1' });
    if (request.path.endsWith('/select-personal-space')) return ok(authResult({ spaceContext: { spaceType: 1 } }));
  });
  for (const [account, loginType] of [['13800000001', 'mobile'], ['alice@example.test', 'email'], ['legacy-id', 'lpp_id']]) {
    await client.loginWithPassword({ account, password: 'fixture-password' });
    assert.equal(requests.filter(r => r.path.endsWith('/auth/login')).at(-1).body.loginType, loginType);
  }
});

test('friend search, request outcomes, incoming actions and new groups use existing server contracts', async t => {
  let accepted = false;
  const { client, requests } = await harness(t, request => {
    if (request.path.endsWith('/search/users')) {
      assert.equal(request.url.searchParams.get('keyword'), 'A & B');
      return ok([{ userId: 'peer-1', displayName: 'Alice', isFriend: false, lppId: 'alice' }]);
    }
    if (request.path.endsWith('/friends/request')) return ok({ requestId: 'sent-1', status: accepted ? 'accepted' : 'pending' });
    if (request.path.endsWith('/friends/requests')) return ok([{ requestId: 'r/1', fromUserId: 'peer-1', fromDisplayName: 'Alice', toUserId: 'user-1', status: 'pending' }]);
    if (request.path.endsWith('/friends/requests/r%2F1/handle')) return ok({});
    if (request.path.endsWith('/groups/')) return ok({ groupId: 'new-group' });
  });
  await client.authenticate(credentials());
  assert.deepEqual(await client.searchUsers('A & B'), [{ userId: 'peer-1', displayName: 'Alice', isFriend: false, lppId: 'alice' }]);
  assert.equal((await client.sendFriendRequest('peer-1', 'Hello')).status, 'pending');
  accepted = true;
  assert.equal((await client.sendFriendRequest('peer-1')).status, 'accepted');
  assert.equal((await client.listFriendRequests())[0].fromDisplayName, 'Alice');
  await client.handleFriendRequest('r/1', 'accept');
  assert.deepEqual(requests.at(-1).body, { action: 'accept' });
  const group = await client.createGroup({ title: 'Project', memberUserIds: ['peer-1', 'peer-1', 'user-1'] });
  assert.deepEqual(requests.at(-1).body, { title: 'Project', memberUserIds: ['peer-1'] });
  assert.equal(group.type, 'group');
  assert.equal(group.conversationId, 'new-group');
});

test('already-handled friend requests reconcile, invalid actions and self-add are rejected', async t => {
  const { client } = await harness(t, request => {
    if (request.path.endsWith('/handle')) return rejected(409, 'FRIEND_REQUEST_HANDLED');
  });
  await client.authenticate(credentials());
  await client.handleFriendRequest('request-1', 'reject');
  await assert.rejects(client.handleFriendRequest('request-1', 'delete'), { code: 'INVALID_ARGUMENT' });
  await assert.rejects(client.sendFriendRequest('user-1'), { code: 'INVALID_ARGUMENT' });
});

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

// Deliberately unsigned test payloads: only profile/me accepting the exact bearer
// authorizes claim fallback. Decoding this fixture alone never proves identity.
function acceptedTestJwt(overrides = {}) {
  const claims = {
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier': 'user-1',
    platform_user_id: 'platform-1',
    space_type: '1',
    tenant_id: 'personal-tenant-placeholder',
    ...overrides,
  };
  return `${Buffer.from(JSON.stringify({ alg: 'none', typ: 'JWT' })).toString('base64url')}.${Buffer.from(JSON.stringify(claims)).toString('base64url')}.fixture-signature`;
}

test('accepted personal JWT string space_type overrides its tenant placeholder', async (t) => {
  const accessToken = acceptedTestJwt();
  const { client, requests } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/profile/me') {
      assert.equal(request.headers.get('Authorization'), `Bearer ${accessToken}`);
      return ok({ userId: 'user-1' });
    }
  });
  await client.authenticate(credentials({ accessToken }));
  assert.deepEqual(client.currentUser, { ...identity, spaceId: 'personal' });
  assert.equal(requests.length, 1);
});

test('accepted tenant JWT cannot activate credentials that claim personal space', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/profile/me') return ok({ userId: 'user-1' });
  });
  const accessToken = acceptedTestJwt({ space_type: '2', tenant_id: 'tenant-1' });
  await assert.rejects(client.authenticate(credentials({ accessToken })),
    (error) => error instanceof ImSdkError && error.code === 'AUTH_EXTERNAL_IDENTITY_MISMATCH');
  assert.equal(client.currentUser, undefined);
});

test('JWT space fallback rejects a subject that differs from the accepted profile', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/profile/me') return ok(identity);
  });
  const accessToken = acceptedTestJwt({
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier': 'other-user',
  });
  await assert.rejects(client.authenticate(credentials({ accessToken })),
    (error) => error instanceof ImSdkError && error.code === 'AUTH_EXTERNAL_IDENTITY_MISMATCH');
  assert.equal(client.isAuthenticated, false);
});

test('explicit profile space cannot be replaced by a personal JWT claim', async (t) => {
  const { client } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/profile/me') return ok({ ...identity, spaceContext: { spaceType: 2, tenantId: 'tenant-1' } });
  });
  await assert.rejects(client.authenticate(credentials({ accessToken: acceptedTestJwt() })),
    (error) => error instanceof ImSdkError && error.code === 'AUTH_EXTERNAL_IDENTITY_MISMATCH');
  assert.equal(client.isAuthenticated, false);
});

test('personal space normalizes numeric JWT and string DTO space types', async (t) => {
  const { client, createClient } = await harness(t, (request) => {
    if (request.path === '/api/client/v1/profile/me') {
      return request.headers.get('Authorization') === 'Bearer opaque-dto-token'
        ? ok({ ...identity, tenantId: 'personal-tenant-placeholder', spaceContext: { spaceType: '1' } })
        : ok({ userId: 'user-1' });
    }
  });
  await client.authenticate(credentials({ accessToken: acceptedTestJwt({ space_type: 1 }) }));
  assert.equal(client.currentUser.spaceId, 'personal');
  const dtoClient = createClient();
  await dtoClient.authenticate(credentials({ accessToken: 'opaque-dto-token' }));
  assert.equal(dtoClient.currentUser.spaceId, 'personal');
});
