import { ImSdkClient } from '../web/dist/index.js';
import { readFile, writeFile, rename, chmod, mkdir } from 'node:fs/promises';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { randomUUID, createHash } from 'node:crypto';

// Auxiliary test identity writes only its two planned friendship operations.
// Primary iOS/Android identities are authenticated here for independent GETs;
// their registrations, friendship actions, groups and messages stay in native UI.
const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const option = key => { const i = process.argv.indexOf(key); return i < 0 ? undefined : process.argv[i + 1]; };
const phase = option('--phase') || 'identities';
const sides = (option('--actors') || 'ios,android,helper').split(',');
const fixturePath = resolve(option('--fixture') || resolve(root, '.work/runtime-private/native-connected-20261028.json'));
const fixture = JSON.parse(await readFile(fixturePath, 'utf8'));
const stateDir = resolve(root, fixture.stateDirectory);
const statePath = resolve(stateDir, 'helper-state.json');
const evidence = resolve(root, 'logs/native-connected-20261028/peer');
if (!fixturePath.startsWith(resolve(root, '.work/runtime-private') + '/') || !stateDir.startsWith(resolve(root, '.work/runtime-private') + '/')) throw new Error('Private task paths required');
if (!['identities', 'helper-friends', 'inspect-group', 'verify'].includes(phase) || sides.some(side => !['ios', 'android', 'helper'].includes(side))) throw new Error('Unsupported phase or identity');
await mkdir(evidence, { recursive: true });
let state = JSON.parse(await readFile(statePath, 'utf8'));
if (state.runId !== fixture.runId) throw new Error('Run mismatch');
const hash = data => createHash('sha256').update(data).digest('hex');
const stamp = new Date().toISOString().replace(/[^0-9]/g, '');
const clients = {};
const report = { runId: fixture.runId, phase, startedAt: new Date().toISOString(), passed: false,
  primaryBusinessWrites: 0, helperFriendWritesThisAttempt: 0, independentRawHttpReads: true,
  checks: {}, requests: [], stages: [], errors: [] };
const ensure = (value, code) => { if (!value) throw Object.assign(new Error(code), { code }); };
async function privateWrite(path, data) {
  const temporary = path + '.' + randomUUID() + '.tmp';
  await writeFile(temporary, JSON.stringify(data, null, 2) + '\n', { mode: 0o600 });
  await chmod(temporary, 0o600); await rename(temporary, path);
}
const persist = () => privateWrite(statePath, state);
async function login(side) {
  if (clients[side]) return clients[side];
  const client = new ImSdkClient();
  client.initialize({ ...fixture.configuration, realtime: false });
  const account = fixture.accounts[side];
  let restored = false;
  if (state.credentials?.[side]) {
    try { await client.authenticate(state.credentials[side]); restored = true; } catch { /* Refresh through a normal password login. */ }
  }
  if (!restored) {
    let captcha;
    for (let attempt = 0; attempt < 3; attempt++) {
      try { await client.loginWithPassword({ account: account.identifier, password: account.password, ...captcha }); break; }
      catch (error) {
        if (!/CAPTCHA/i.test(error.code || '')) throw error;
        const challenge = await client.requestLoginCaptcha();
        const m = challenge.question.match(/(-?\d+)\s*([+\-*×/÷])\s*(-?\d+)/);
        ensure(m, 'NORMAL_CAPTCHA_INPUT_REQUIRED');
        const a = Number(m[1]), b = Number(m[3]);
        const answer = m[2] === '+' ? a + b : m[2] === '-' ? a - b : ['*', '×'].includes(m[2]) ? a * b : a / b;
        ensure(Number.isInteger(answer), 'NORMAL_CAPTCHA_INPUT_REQUIRED');
        captcha = { captchaToken: challenge.token, captchaAnswer: String(answer) };
      }
    }
  }
  ensure(client.isAuthenticated && client.currentUser?.userId, 'ACCEPTED_IDENTITY_REQUIRED');
  const identity = client.currentUser;
  if (state.identities[side]) ensure(JSON.stringify(identity) === JSON.stringify(state.identities[side]), 'PRIMARY_IDENTITY_CHANGED');
  state.identities[side] = identity;
  state.credentials ??= {}; state.credentials[side] = { ...client.credentials };
  clients[side] = client;
  await persist();
  report.stages.push({ stage: 'acceptedIndependentIdentity', actor: side, passwordSubmitted: !restored });
  return client;
}
const rows = data => Array.isArray(data) ? data : data?.items || [];
const contactId = row => row.friendUserId || row.userId;
const textOf = row => { try { return (typeof row.body === 'string' ? JSON.parse(row.body) : row.body)?.text; } catch { return undefined; } };
const seqOf = row => Number(row.conversationSeq ?? row.seq ?? 0);
async function rawRead(side, path) {
  const client = await login(side);
  ensure(path.startsWith('/api/client/v1/'), 'READ_SCOPE_MISMATCH');
  const response = await fetch(fixture.configuration.apiBaseUrl.replace(/\/+$/, '') + path, {
    headers: { Accept: 'application/json', Authorization: 'Bearer ' + client.credentials.accessToken },
    redirect: 'error', signal: AbortSignal.timeout(25000), cache: 'no-store',
  });
  const data = await response.json();
  report.requests.push({ actor: side, method: 'GET', path: path.split('?')[0].replace(/[0-9a-f]{8}-[0-9a-f-]{27,}/gi, ':id'), status: response.status });
  ensure(response.ok && data.code === 'OK', 'INDEPENDENT_READ_FAILED');
  await privateWrite(resolve(stateDir, `${stamp}-${side}-${hash(path).slice(0, 14)}.json`), { path, status: response.status, envelope: data });
  return data.data;
}
async function helperFriends() {
  for (const side of ['ios', 'android', 'helper']) await login(side);
  ensure(new Set(Object.values(state.identities).map(user => user.userId)).size === 3, 'THREE_DISTINCT_IDENTITIES_REQUIRED');
  ensure(new Set(Object.values(state.identities).map(user => user.spaceId)).size === 1, 'DEDICATED_IDENTITIES_NOT_IN_SAME_SPACE');
  const androidState = JSON.parse(await readFile(resolve(stateDir, 'android-state.json'), 'utf8'));
  ensure(androidState.runId === fixture.runId && androidState.friendRequestToHelperSubmitted === true, 'NATIVE_ANDROID_REQUEST_NOT_SUBMITTED');
  const helper = clients.helper;
  let requests = await helper.listFriendRequests();
  const androidRequests = requests.filter(row => row.fromUserId === state.identities.android.userId && row.toUserId === state.identities.helper.userId);
  ensure(androidRequests.length === 1, 'DEDICATED_ANDROID_REQUEST_NOT_UNIQUE');
  if (androidRequests[0].status === 'pending') {
    state.helperAcceptIntent = true; await persist();
    await helper.handleFriendRequest(androidRequests[0].requestId, 'accept');
    report.helperFriendWritesThisAttempt++;
  }
  ensure(rows(await rawRead('helper', '/api/client/v1/friends')).some(row => contactId(row) === state.identities.android.userId), 'HELPER_ANDROID_FRIENDSHIP_NOT_PERSISTED');
  ensure(rows(await rawRead('android', '/api/client/v1/friends')).some(row => contactId(row) === state.identities.helper.userId), 'ANDROID_HELPER_FRIENDSHIP_NOT_PERSISTED');
  state.helperAcceptedAndroid = true; await persist(); report.checks.helperAcceptedNativeAndroidRequest = true;
  requests = await helper.listFriendRequests();
  const iosRequests = requests.filter(row => row.fromUserId === state.identities.helper.userId && row.toUserId === state.identities.ios.userId);
  ensure(iosRequests.length <= 1, 'HELPER_IOS_REQUEST_NOT_UNIQUE');
  if (!iosRequests.length) {
    ensure(!state.helperRequestIntent, 'HELPER_REQUEST_OUTCOME_UNCERTAIN');
    state.helperRequestIntent = true; await persist();
    const submitted = await helper.sendFriendRequest(state.identities.ios.userId, state.requestToIosMarker);
    ensure(submitted.status === 'pending', 'HELPER_IOS_REQUEST_NOT_PENDING');
    state.helperToIosRequestId = submitted.requestId;
    report.helperFriendWritesThisAttempt++;
  } else state.helperToIosRequestId = iosRequests[0].requestId;
  const incoming = (await clients.ios.listFriendRequests()).filter(row => row.requestId === state.helperToIosRequestId && row.fromUserId === state.identities.helper.userId && row.toUserId === state.identities.ios.userId && row.message === state.requestToIosMarker);
  ensure(incoming.length === 1 && ['pending', 'accepted'].includes(incoming[0].status), 'HELPER_IOS_INCOMING_NOT_VERIFIED');
  state.helperRequestedIos = true; await persist(); report.checks.helperRequestAvailableForNativeIosAcceptance = true;
}
async function verify() {
  for (const side of ['ios', 'android', 'helper']) await login(side);
  const users = state.identities;
  for (const side of ['ios', 'android']) {
    const contacts = rows(await rawRead(side, '/api/client/v1/friends'));
    ensure(['ios', 'android', 'helper'].filter(other => other !== side).every(other => contacts.some(row => contactId(row) === users[other].userId)), 'NATIVE_FRIENDSHIPS_NOT_BOTH_PERSISTED');
  }
  report.checks.nativeAndHelperFriendshipsPersisted = true;
  const lists = {};
  for (const side of ['ios', 'android']) lists[side] = (await clients[side].listConversations({ limit: 100 })).items;
  const direct = lists.ios.filter(row => row.type === 'direct' && row.peerUserId === users.android.userId);
  ensure(direct.length === 1 && lists.android.some(row => row.conversationId === direct[0].conversationId && row.type === 'direct' && row.peerUserId === users.ios.userId), 'SHARED_NATIVE_DIRECT_NOT_VERIFIED');
  const conversations = [{ kind: 'direct', value: direct[0], markers: fixture.messages.direct }];
  for (const creator of ['ios', 'android']) {
    const groups = lists[creator].filter(row => row.type === 'group' && row.title === fixture.groups[creator]);
    ensure(groups.length === 1, 'NATIVE_GROUP_NOT_UNIQUE');
    const group = groups[0];
    for (const side of ['ios', 'android']) {
      const detail = await rawRead(side, `/api/client/v1/groups/${encodeURIComponent(group.conversationId)}`);
      const members = rows(await rawRead(side, `/api/client/v1/groups/${encodeURIComponent(group.conversationId)}/members`));
      const ids = members.map(row => row.userId || row.memberUserId || row.targetUserId || row.id || row.user?.userId);
      ensure(detail.ownerUserId === users[creator].userId && ids.length === 2 && new Set(ids).size === 2 && ids.includes(users.ios.userId) && ids.includes(users.android.userId), 'NATIVE_GROUP_OWNER_OR_MEMBERS_MISMATCH');
    }
    conversations.push({ kind: creator + 'Group', value: group, markers: fixture.messages[creator + 'Group'], creator });
  }
  let total = 0;
  for (const target of conversations) {
    const prefix = target.kind === 'direct' ? 'direct-chats' : 'groups';
    const sequences = {};
    for (const reader of ['ios', 'android']) {
      const history = rows(await rawRead(reader, `/api/client/v1/${prefix}/${encodeURIComponent(target.value.conversationId)}/messages?limit=100`));
      const found = {};
      for (const sender of ['ios', 'android']) {
        const messages = history.filter(row => row.senderUserId === users[sender].userId && textOf(row) === target.markers[sender]);
        ensure(messages.length === 1 && seqOf(messages[0]) > 0, 'NATIVE_MARKER_NOT_PERSISTED_EXACTLY_ONCE');
        found[sender] = seqOf(messages[0]);
      }
      ensure(found.ios !== found.android, 'NATIVE_SEQUENCE_NOT_DISTINCT');
      if (target.kind === 'direct') ensure(found.ios < found.android, 'NATIVE_DIRECT_REPLY_ORDER_MISMATCH');
      if (target.creator) ensure(found[target.creator] < found[target.creator === 'ios' ? 'android' : 'ios'], 'NATIVE_GROUP_REPLY_ORDER_MISMATCH');
      if (sequences.ios) ensure(JSON.stringify(found) === JSON.stringify(sequences.ios), 'INDEPENDENT_READERS_DISAGREE');
      sequences[reader] = found;
    }
    report.checks[target.kind + 'ExactSenderBodyAndSequence'] = true;
    state.independentReads[target.kind] = { conversationId: target.value.conversationId, sequences, markers: target.markers, exactMembersVerified: target.kind !== 'direct' };
    report.stages.push({ stage: 'nativeConversationPersistedByBothIdentities', conversationKind: target.kind, sequences: sequences.ios });
    total += 2;
  }
  ensure(total === 6, 'SIX_NATIVE_MESSAGES_REQUIRED');
  report.newNativeMessagesPersisted = total; report.newNativeGroupsVerified = 2;
  state.independentVerificationComplete = true; await persist();
}
async function inspectGroup() {
  const creator = option('--creator');
  ensure(['ios', 'android'].includes(creator), 'VALID_GROUP_CREATOR_REQUIRED');
  for (const side of ['ios', 'android']) await login(side);
  const groups = (await clients[creator].listConversations({ limit: 100 })).items.filter(row => row.type === 'group' && row.title === fixture.groups[creator]);
  ensure(groups.length === 1, 'INSPECTED_GROUP_NOT_UNIQUE');
  const id = encodeURIComponent(groups[0].conversationId);
  const found = {};
  for (const reader of ['ios', 'android']) {
    const detail = await rawRead(reader, `/api/client/v1/groups/${id}`);
    const members = rows(await rawRead(reader, `/api/client/v1/groups/${id}/members`));
    const ids = members.map(row => row.userId || row.memberUserId || row.targetUserId || row.id || row.user?.userId);
    ensure(detail.ownerUserId === state.identities[creator].userId && ids.length === 2 && new Set(ids).size === 2 && ids.includes(state.identities.ios.userId) && ids.includes(state.identities.android.userId), 'INSPECTED_GROUP_SCOPE_MISMATCH');
    const history = rows(await rawRead(reader, `/api/client/v1/groups/${id}/messages?limit=100`));
    found[reader] = {};
    for (const sender of ['ios', 'android']) {
      const messages = history.filter(row => row.senderUserId === state.identities[sender].userId && textOf(row) === fixture.messages[creator + 'Group'][sender]);
      ensure(messages.length <= 1, 'INSPECTED_MARKER_DUPLICATED');
      found[reader][sender] = messages.length ? seqOf(messages[0]) : null;
    }
  }
  ensure(JSON.stringify(found.ios) === JSON.stringify(found.android), 'INDEPENDENT_GROUP_INSPECTIONS_DISAGREE');
  report.checks.inspectedGroupOwnerAndExactTwoMembers = true;
  report.groupCreator = creator; report.markerSequences = found.ios;
  report.markersPresent = Object.fromEntries(Object.entries(found.ios).map(([side, seq]) => [side, seq !== null]));
  state.lastGroupInspection = { creator, conversationId: groups[0].conversationId, at: new Date().toISOString(), markerSequences: found.ios };
  await persist();
}
try {
  if (phase === 'identities') { for (const side of sides) await login(side); report.checks.acceptedRequestedIdentities = true; }
  else if (phase === 'helper-friends') await helperFriends();
  else if (phase === 'inspect-group') await inspectGroup();
  else await verify();
  report.passed = true;
} catch (error) {
  report.errors.push(/^[A-Z_0-9.]{1,80}$/.test(error.code || '') ? error.code : 'NATIVE_PEER_VERIFICATION_FAILED');
  await privateWrite(resolve(stateDir, `${stamp}-peer-error.json`), { name: error.name, message: error.message, stack: error.stack });
  process.exitCode = 1;
} finally {
  for (const [side, client] of Object.entries(clients)) { state.credentials[side] = { ...client.credentials }; await client.shutdown().catch(() => {}); }
  await persist(); report.finishedAt = new Date().toISOString();
  await writeFile(resolve(evidence, `${stamp}-${phase}.json`), JSON.stringify(report, null, 2) + '\n');
  await writeFile(resolve(evidence, `${phase}.json`), JSON.stringify(report, null, 2) + '\n');
  console.log(JSON.stringify({ phase, passed: report.passed, errors: report.errors, checks: report.checks, markersPresent: report.markersPresent, markerSequences: report.markerSequences }));
}
