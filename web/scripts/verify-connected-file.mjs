import { chromium, expect } from '@playwright/test';
import { readFile, writeFile, mkdir, access } from 'node:fs/promises';
import { resolve, dirname, basename, relative } from 'node:path';
import { pathToFileURL, fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';
import assert from 'node:assert/strict';

// Real file-origin verification using only an already authorized test account.
// No response interception, configuration injection, registration or sends.
const root = resolve(fileURLToPath(new URL('../..', import.meta.url)));
const args = process.argv.slice(2);
const option = key => { const i = args.indexOf(key); return i < 0 ? undefined : args[i + 1]; };
if (!option('--fixture')) throw new Error('A private authorized fixture is required');
const fixturePath = resolve(option('--fixture'));
const fixture = JSON.parse(await readFile(fixturePath, 'utf8'));
const account = fixture.accounts.web;
const delivery = resolve(option('--delivery') ?? resolve(root, '.codex-build/web-connected-20261028/file-handoff'));
const label = option('--label') ?? 'source';
assert(/^[a-zA-Z0-9_-]{1,70}$/.test(label));
const evidence = resolve(option('--evidence') ?? resolve(root, 'logs/web-connected-20261028'));
await mkdir(evidence, { recursive: true });
let entry = resolve(delivery, 'index.html');
try { await access(entry); } catch { entry = resolve(delivery, 'examples/plain-html/index.html'); }
const deepEntry = resolve(delivery, 'examples/plain-html/index.html');
const configPath = resolve(delivery, 'examples/plain-html/host-config.js');
const bundlePath = resolve(delivery, 'sdk/im-sdk.js');
const hash = data => createHash('sha256').update(data).digest('hex');
let expectedUser;
try { expectedUser = JSON.parse(await readFile(resolve(dirname(fixturePath), basename(fixturePath, '.json') + '-web-status.json'), 'utf8')).user; } catch {}
const report = { sdkVersion: JSON.parse(await readFile(resolve(root, 'web/package.json'), 'utf8')).version,
  startedAt: new Date().toISOString(), passed: false, realBackend: true, mockedApiResponses: false,
  configurationDynamicallyInjected: false, fileOrigin: true, actualDeliveredEntry: !!option('--delivery'),
  entry: relative(root, entry), entrySha256: hash(await readFile(deepEntry)),
  hostConfigSha256: hash(await readFile(configPath)), bundleSha256: hash(await readFile(bundlePath)),
  checks: {}, requests: [], errors: [], newAccounts: 0, newMessages: 0, newGroups: 0, verificationMessagesSent: 0 };
if (entry !== deepEntry) report.rootEntrySha256 = hash(await readFile(entry));
const browser = await chromium.launch({ channel: 'chrome', headless: true });
const page = await browser.newPage({ viewport: { width: 430, height: 900 } });
const apiOrigin = new URL(fixture.configuration.apiBaseUrl).origin;
page.on('pageerror', () => report.errors.push('PAGE_ERROR'));
page.on('response', response => {
  const url = new URL(response.url()); if (url.origin !== apiOrigin) return;
  const request = response.request();
  report.requests.push({ path: url.pathname, method: request.method(), status: response.status(), origin: request.headers().origin ?? null, allowOrigin: response.headers()['access-control-allow-origin'] ?? null });
  if (request.method() === 'POST') {
    if (url.pathname.endsWith('/auth/register')) report.newAccounts++;
    if (url.pathname.endsWith('/messages')) report.newMessages++;
    if (/\/groups\/?$/.test(url.pathname)) report.newGroups++;
    if (url.pathname.endsWith('/verification/send')) report.verificationMessagesSent++;
  }
});
async function screenshot(name) {
  await page.screenshot({ path: resolve(evidence, `${label}-${name}.png`), fullPage: true,
    mask: [page.getByPlaceholder('账号', { exact: true }), page.getByPlaceholder('密码', { exact: true }),
      page.locator('.meta').filter({ hasText: /[0-9a-f]{8}-[0-9a-f-]{27,}/i })] });
}
try {
  await page.goto(pathToFileURL(entry).href);
  await expect(page.getByRole('button', { name: '登录', exact: true })).toBeVisible();
  await expect(page.getByRole('button', { name: '注册新账号', exact: true })).toBeVisible();
  assert.equal(await page.getByLabel('IM API 服务地址', { exact: true }).count(), 0);
  const profile = await page.evaluate(() => ({ initialized: IMSDK_HOST.client.isInitialized, config: IMSDK_HOST_CONFIG }));
  assert(profile.initialized && profile.config.apiBaseUrl === fixture.configuration.apiBaseUrl && profile.config.serviceRealmId === fixture.configuration.serviceRealmId);
  assert.equal(profile.config.storageNamespace, undefined);
  assert.deepEqual(profile.config.passwordLogin, { space: 'personal', loginType: 'lpp_id' });
  report.checks.authorizedRealProfileLoadedWithoutUserConfiguration = true;
  const settings = page.waitForResponse(response => new URL(response.url()).pathname.endsWith('/verification/settings') && response.status() === 200);
  await page.getByRole('button', { name: '注册新账号', exact: true }).click();
  await settings;
  await expect.poll(async () => page.getByLabel('注册方式', { exact: true }).locator('option').count(), { timeout: 20000 }).toBeGreaterThan(0);
  report.checks.registrationSettingsReadableFromRealFileOrigin = true;
  await screenshot('registration-real-settings');
  await page.getByRole('button', { name: '返回登录', exact: true }).click();
  await page.evaluate(() => { window.fileProbeEvents = []; IMSDK_HOST.client.on(event => fileProbeEvents.push({ type: event.type, code: event.code })); });
  await page.getByPlaceholder('账号', { exact: true }).fill(account.identifier);
  await page.getByPlaceholder('密码', { exact: true }).fill(account.password);
  await page.getByRole('button', { name: '登录', exact: true }).click();
  await page.waitForFunction(() => IMSDK_HOST.client.isAuthenticated || fileProbeEvents.some(event => event.type === 'authenticationFailed'), undefined, { timeout: 30000 });
  const state = await page.evaluate(() => ({ authenticated: IMSDK_HOST.client.isAuthenticated, user: IMSDK_HOST.client.currentUser, failure: fileProbeEvents.find(event => event.type === 'authenticationFailed')?.code }));
  assert(state.authenticated, 'REAL_FILE_PASSWORD_LOGIN_FAILED');
  if (expectedUser) assert.deepEqual(state.user, expectedUser);
  await expect(page.getByRole('button', { name: '退出登录', exact: true })).toBeVisible();
  report.checks.realPasswordLoginAutomaticallyShowsConversationList = true;
  report.checks.expectedDedicatedIdentityAccepted = true;
  await screenshot('real-conversation-list');
  await page.getByRole('button', { name: '关闭', exact: true }).click();
  await page.getByRole('button', { name: '打开聊天', exact: true }).click();
  await expect(page.getByRole('button', { name: '退出登录', exact: true })).toBeVisible();
  assert.equal(await page.getByPlaceholder('账号', { exact: true }).count(), 0);
  report.checks.authenticatedReopenShowsConversationList = true;
  await page.getByRole('button', { name: '退出登录', exact: true }).click();
  await expect(page.getByRole('button', { name: '登录', exact: true })).toBeVisible();
  assert.equal(await page.evaluate(() => IMSDK_HOST.client.currentUser), undefined);
  await page.evaluate(() => IMSDK_HOST.client.shutdown());
  report.checks.logoutAndShutdownClean = true;
  assert.equal(report.newAccounts + report.newMessages + report.newGroups + report.verificationMessagesSent, 0);
  assert.deepEqual(report.errors, []);
  report.passed = true;
} catch (error) {
  report.errors.push(error.name === 'TimeoutError' ? 'FILE_ENTRY_TIMEOUT' : 'FILE_ENTRY_VALIDATION_FAILED');
  await screenshot('failure').catch(() => {}); process.exitCode = 1;
} finally {
  await page.evaluate(() => window.IMSDK_HOST?.client.shutdown()).catch(() => {});
  await browser.close(); report.finishedAt = new Date().toISOString();
  await writeFile(resolve(evidence, `${label}-default-entry-live.json`), JSON.stringify(report, null, 2));
  console.log(JSON.stringify({ passed: report.passed, label, checks: report.checks, errors: report.errors, zeroBusinessWrites: report.newAccounts + report.newMessages + report.newGroups + report.verificationMessagesSent === 0 }));
}
