import assert from 'node:assert/strict';
import { readFile, writeFile, mkdir, readdir, lstat } from 'node:fs/promises';
import { resolve, dirname, relative, sep } from 'node:path';
import { createRequire } from 'node:module';
import { pathToFileURL, fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { createServer } from 'node:http';
import { chromium, expect } from '@playwright/test';

const web = resolve(dirname(fileURLToPath(import.meta.url)), '..'), root = resolve(web, '..');
const args = process.argv.slice(2);
const option = key => { const i = args.indexOf(key); return i < 0 ? undefined : args[i + 1]; };
const version = JSON.parse(await readFile(resolve(web, 'package.json'), 'utf8')).version;
const artifact = resolve(option('--package') ?? resolve(root, `dist/web/imsdk-web-${version}.tgz`));
const work = resolve(option('--work') ?? resolve(root, '.codex-build/web-entry-20261028/web-consumer'));
const evidence = resolve(option('--evidence') ?? resolve(root, 'logs/web-entry-20261028'));
const livePath = resolve(option('--live-report') ?? resolve(evidence, 'source-final-default-entry-live.json'));
assert(work.startsWith(resolve(root, '.codex-build') + sep), 'Consumer extraction must stay in this task build directory');
await mkdir(work, { recursive: true });
assert.equal((await readdir(work)).length, 0, 'Use a fresh empty consumer directory');
await mkdir(evidence, { recursive: true });
const hash = data => createHash('sha256').update(data).digest('hex');
const report = { status: 'running', sdkVersion: version, artifactSha256: hash(await readFile(artifact)), standaloneExtractedOfficialPackage: true, dependencyInstalls: 0, checks: {}, errors: [] };
let browser, server;
async function files(directory) {
  const found = [];
  for (const name of await readdir(directory)) {
    const path = resolve(directory, name), info = await lstat(path);
    assert(!info.isSymbolicLink());
    if (info.isDirectory()) found.push(...await files(path)); else found.push(path);
  }
  return found;
}
try {
  execFileSync('python3', ['-c', `import sys,tarfile,pathlib
with tarfile.open(sys.argv[1],'r:gz') as archive:
 for item in archive.getmembers():
  path=pathlib.PurePosixPath(item.name)
  assert not path.is_absolute() and '..' not in path.parts and path.parts[0]=='package' and (item.isfile() or item.isdir())
 archive.extractall(sys.argv[2])`, artifact, work], { stdio: 'pipe' });
  const pkg = JSON.parse(await readFile(resolve(work, 'package/package.json'), 'utf8'));
  assert.equal(pkg.name, '@imsdk/web'); assert.equal(pkg.version, version);
  assert.deepEqual(pkg.exports['.'], { types: './dist/types/index.d.ts', import: './dist/index.js', require: './dist/index.cjs' });
  for (const file of await files(resolve(work, 'package/dist'))) assert.equal(hash(await readFile(file)), hash(await readFile(resolve(web, 'dist', relative(resolve(work, 'package/dist'), file)))));
  report.bundleSha256 = hash(await readFile(resolve(work, 'package/dist/im-sdk.js')));
  const live = JSON.parse(await readFile(livePath, 'utf8'));
  assert.equal(live.passed, true); assert.equal(live.bundleSha256, report.bundleSha256);
  report.checks.packageExportManifest = report.checks.officialRuntimeAndTypesMatchCurrentBuild = report.checks.sameBundleAsActualRealServiceValidation = true;
  const esm = await import(pathToFileURL(resolve(work, 'package/dist/index.js')).href);
  const cjs = createRequire(import.meta.url)(resolve(work, 'package'));
  for (const [kind, sdk] of [['esm', esm], ['commonjs', cjs]]) {
    for (const name of ['ImSdkClient', 'mountMessenger', 'ImSdkError']) assert.equal(typeof sdk[name], 'function');
    const client = new sdk.ImSdkClient(); let ready = 0;
    client.on(event => { if (event.type === 'ready') ready++; });
    client.initialize({ apiBaseUrl: 'https://sdk-consumer.example.invalid', serviceRealmId: 'standalone-consumer', privacyConsentGranted: true, realtime: false });
    for (const name of ['registerWithPassword', 'loginWithPassword', 'getRegistrationVerificationSettings', 'sendRegistrationCode', 'listConversations', 'listMessages', 'sendText', 'searchUsers', 'sendFriendRequest', 'listFriendRequests', 'handleFriendRequest', 'createGroup']) assert.equal(typeof client[name], 'function');
    assert.equal(ready, 1); assert.equal(client.isAuthenticated, false); await client.shutdown(); assert.equal(client.isInitialized, false);
    report.checks[kind + 'StandaloneRuntime'] = true;
  }
  await writeFile(resolve(work, 'consumer.mts'), `import {ImSdkClient,mountMessenger,type RegistrationRequest,type RegistrationCodeRequest,type RegistrationVerificationSettings,type CreateGroupRequest,type Conversation,type FriendRequest,type FriendRequestSubmission,type UserSearchResult} from './package/dist/types/index.js';
const client=new ImSdkClient();
const register:(r:RegistrationRequest)=>Promise<void>=client.registerWithPassword.bind(client);
const code:(r:RegistrationCodeRequest)=>Promise<void>=client.sendRegistrationCode.bind(client);
const settings:()=>Promise<RegistrationVerificationSettings>=client.getRegistrationVerificationSettings.bind(client);
const group:(r:CreateGroupRequest)=>Promise<Conversation>=client.createGroup.bind(client);
const search:(q:string)=>Promise<UserSearchResult[]>=client.searchUsers.bind(client);
const request:(id:string,message?:string)=>Promise<FriendRequestSubmission>=client.sendFriendRequest.bind(client);
const requests:()=>Promise<FriendRequest[]>=client.listFriendRequests.bind(client);
void [register,code,settings,group,search,request,requests,mountMessenger];`);
  execFileSync(process.execPath, [resolve(web, 'node_modules/typescript/bin/tsc'), '--noEmit', '--strict', '--target', 'ES2020', '--module', 'NodeNext', '--moduleResolution', 'NodeNext', '--lib', 'ES2020,DOM,DOM.Iterable', '--skipLibCheck', resolve(work, 'consumer.mts')], { cwd: work, stdio: 'pipe' });
  report.checks.standalonePublicTypeConsumer = true;
  const privateValues = new Set();
  function collect(value) {
    if (Array.isArray(value)) { for (const item of value) collect(item); return; }
    if (!value || typeof value !== 'object') return;
    for (const [key, item] of Object.entries(value)) {
      if (typeof item === 'string' && item.length >= 8 && (/token|password/i.test(key) || ['identifier', 'account', 'loginName', 'email', 'apiBaseUrl', 'serviceRealmId'].includes(key))) privateValues.add(item);
      else if (item && typeof item === 'object') collect(item);
    }
  }
  for (const path of (await files(resolve(root, '.work/runtime-private'))).filter(path => path.endsWith('.json'))) { try { collect(JSON.parse(await readFile(path, 'utf8'))); } catch {} }
  for (const path of await files(resolve(work, 'package'))) {
    assert(!/(^|\/)(\.work|runtime-private|\.env)(\/|$)/.test(relative(resolve(work, 'package'), path)));
    const text = await readFile(path, 'utf8');
    for (const value of privateValues) assert(!text.includes(value), 'PRIVATE_VALUE_FOUND_IN_DELIVERED_PACKAGE');
  }
  report.checks.noKnownPrivateAccountsTokensOrConfiguredServiceValues = true;
  assert((await readFile(resolve(work, 'package/example/host-config.js'), 'utf8')).includes('IMSDK_HOST_CONFIG'));
  const requests = [], errors = [];
  server = createServer(async (request, response) => {
    if (request.url === '/') { response.writeHead(302, { Location: '/package/example/index.html' }).end(); return; }
    const path = resolve(work, '.' + new URL(request.url, 'http://localhost').pathname);
    if (!path.startsWith(work + sep)) { response.writeHead(403).end(); return; }
    try { response.setHeader('Content-Type', path.endsWith('.js') ? 'application/javascript' : 'text/html; charset=utf-8'); response.end(await readFile(path)); }
    catch { response.writeHead(404).end(); }
  });
  await new Promise(r => server.listen(0, '127.0.0.1', r));
  const origin = `http://127.0.0.1:${server.address().port}`;
  browser = await chromium.launch({ channel: 'chrome', headless: true });
  const page = await browser.newPage({ viewport: { width: 390, height: 844 } });
  page.on('request', request => requests.push(request.url())); page.on('pageerror', () => errors.push('PAGE_ERROR'));
  await page.goto(origin);
  await expect(page.getByRole('button', { name: '登录', exact: true })).toBeVisible();
  await expect(page.getByRole('button', { name: '注册新账号', exact: true })).toBeVisible();
  assert.equal(await page.getByLabel('IM API 服务地址', { exact: true }).count(), 0);
  await page.getByRole('button', { name: '注册新账号', exact: true }).click();
  await expect(page.getByPlaceholder('昵称', { exact: true })).toBeVisible();
  await page.screenshot({ path: resolve(evidence, 'consumer-default-entry.png'), fullPage: true });
  await page.evaluate(() => IMSDK_HOST.client.shutdown());
  assert.deepEqual(errors, []); assert(requests.every(url => new URL(url).origin === origin));
  assert(!requests.some(url => new URL(url).pathname.includes('/src/')));
  report.checks.standaloneBrowserIifeDefaultEntry = report.checks.noOriginalSourceOrExternalRuntimeRequests = true;
  report.browserVersion = browser.version(); report.status = 'passed';
} catch (error) { report.status = 'failed'; report.errors.push(error.message === 'PRIVATE_VALUE_FOUND_IN_DELIVERED_PACKAGE' ? error.message : 'CONSUMER_VALIDATION_FAILED'); process.exitCode = 1; }
finally {
  if (browser) await browser.close(); if (server) await new Promise(r => server.close(r));
  report.finishedAt = new Date().toISOString();
  await writeFile(resolve(evidence, 'consumer-validation.json'), JSON.stringify(report, null, 2));
  console.log(JSON.stringify(report));
}
