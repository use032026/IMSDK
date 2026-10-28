import { chromium, expect } from '@playwright/test';
import { createServer } from 'node:http';
import { readFile, writeFile, mkdir, copyFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { pathToFileURL } from 'node:url';
import assert from 'node:assert/strict';

const root = resolve('..');
const evidence = resolve(process.env.IMSDK_ENTRY_EVIDENCE_DIR ?? resolve(root, 'logs/web-connected-20261028'));
const work = resolve(process.env.IMSDK_ENTRY_WORK_DIR ?? resolve(root, '.codex-build/web-connected-20261028/file-handoff'));
await mkdir(evidence, { recursive: true });
await mkdir(resolve(work, 'examples/plain-html'), { recursive: true });
await mkdir(resolve(work, 'sdk'), { recursive: true });
for (const name of ['index.html', 'host-config.js']) await copyFile(resolve('handoff/examples/plain-html', name), resolve(work, 'examples/plain-html', name));
await copyFile(resolve('dist/im-sdk.js'), resolve(work, 'sdk/im-sdk.js'));
const html = await readFile(resolve('example/index.html'), 'utf8');
const bootstrap = [...html.matchAll(/<script(?:\s[^>]*)?>([\s\S]*?)<\/script>/g)].map(match => match[1]).find(text => text.trim());
assert(bootstrap);
const server = createServer(async (request, response) => {
  const path = new URL(request.url, 'http://localhost').pathname;
  let file;
  if (path === '/' || path === '/external.html') {
    response.setHeader('Content-Type', 'text/html; charset=utf-8');
    response.end(path === '/external.html' ? html.replace(bootstrap, '') : html); return;
  }
  if (path === '/host-config.js') file = resolve('example/host-config.js');
  if (path === '/dist/im-sdk.js') file = resolve('dist/im-sdk.js');
  if (!file) { response.writeHead(404).end(); return; }
  response.setHeader('Content-Type', 'application/javascript'); response.end(await readFile(file));
});
await new Promise(r => server.listen(0, '127.0.0.1', r));
const origin = `http://127.0.0.1:${server.address().port}`;
const browser = await chromium.launch({ channel: 'chrome', headless: true });
const report = { fixture: true, liveBackend: false, explicitConfigurationOverride: true, checks: [], errors: [], temporaryWork: work };
const configuration = { apiBaseUrl: 'https://entry.example.test', serviceRealmId: 'entry-test', privacyConsentGranted: true, realtime: false, pollIntervalMs: 27000 };
const credentials = { userId: 'fixture-user', platformUserId: 'fixture-platform', spaceId: 'personal', accessToken: 'fixture-access', refreshToken: 'fixture-refresh', expiresAt: new Date(Date.now() + 3600000).toISOString() };
const allContexts = [];
async function contextPage(configurationOverride = null) {
  const context = await browser.newContext({ viewport: { width: 390, height: 844 } });
  allContexts.push(context);
  const page = await context.newPage(); const calls = []; const errors = [];
  await page.addInitScript(value => { window.IMSDK_HOST_CONFIG = value; }, configurationOverride);
  page.on('pageerror', () => errors.push('PAGE_ERROR'));
  await page.route('https://entry.example.test/**', async route => {
    const path = new URL(route.request().url()).pathname; calls.push(path);
    let data;
    if (path.endsWith('/verification/settings')) data = { smsEnabled: true, emailEnabled: true, smsRequired: false, emailRequired: false };
    else if (path.endsWith('/profile/me')) data = { userId: 'fixture-user', platformUserId: 'fixture-platform', spaceContext: { spaceType: 1 } };
    else if (path.endsWith('/conversations')) data = { items: [] };
    else throw new Error('UNEXPECTED_FIXTURE_REQUEST');
    await route.fulfill({ json: { code: 'OK', data } });
  });
  await page.addInitScript(() => {
    window.entryIntervals = []; window.entryClearedIntervals = [];
    const start = window.setInterval.bind(window), stop = window.clearInterval.bind(window);
    window.setInterval = (callback, delay, ...args) => { const id = start(callback, delay, ...args); entryIntervals.push({ id, delay }); return id; };
    window.clearInterval = id => { entryClearedIntervals.push(id); stop(id); };
  });
  return { context, page, calls, errors };
}
try {
  {
    const { page, calls, errors } = await contextPage();
    await page.goto(origin);
    await expect(page.getByRole('button', { name: '登录', exact: true })).toBeVisible();
    await expect(page.getByRole('button', { name: '注册新账号', exact: true })).toBeVisible();
    for (const label of ['IM API 服务地址', '服务环境标识', '聊天空间']) assert.equal(await page.getByLabel(label, { exact: true }).count(), 0);
    assert.equal(await page.getByRole('checkbox').count(), 0);
    await page.getByPlaceholder('账号', { exact: true }).fill('fixture-user');
    await page.getByPlaceholder('密码', { exact: true }).fill('fixture-password');
    await page.getByRole('button', { name: '登录', exact: true }).click();
    await page.getByRole('button', { name: '安全验证', exact: true }).click();
    await expect(page.getByRole('alert')).toContainText('聊天服务暂未就绪');
    await page.getByRole('button', { name: '注册新账号', exact: true }).click();
    await expect(page.getByPlaceholder('昵称', { exact: true })).toBeVisible();
    await expect(page.getByRole('button', { name: '注册并登录', exact: true })).toBeDisabled();
    await expect(page.getByRole('button', { name: '发送验证码', exact: true })).toBeDisabled();
    await page.getByRole('button', { name: '重新加载注册方式', exact: true }).click();
    assert.equal(calls.length, 0);
    assert.equal(await page.evaluate(() => entryIntervals.length), 0);
    await page.screenshot({ path: resolve(evidence, 'unconfigured-registration.png'), fullPage: true });
    await page.evaluate(config => IMSDK_HOST.configure(config), configuration);
    await expect(page.getByLabel('注册方式', { exact: true })).toHaveValue('sms');
    assert.equal(calls.length, 1);
    assert.equal(calls[0], '/api/platform/v1/auth/verification/settings');
    const interval = await page.evaluate(() => entryIntervals.at(-1));
    assert.equal(interval.delay, configuration.pollIntervalMs);
    await page.getByRole('button', { name: '返回登录', exact: true }).click();
    await page.evaluate(credentials => IMSDK_HOST.client.authenticate(credentials), credentials);
    await expect(page.getByRole('button', { name: '退出登录', exact: true })).toBeVisible();
    await page.getByRole('button', { name: '关闭', exact: true }).click();
    await expect(page.getByRole('button', { name: '打开聊天', exact: true })).toBeVisible();
    assert(await page.evaluate(id => entryClearedIntervals.includes(id), interval.id));
    await page.getByRole('button', { name: '打开聊天', exact: true }).click();
    await expect(page.getByRole('button', { name: '退出登录', exact: true })).toBeVisible();
    assert.equal(await page.getByPlaceholder('账号', { exact: true }).count(), 0);
    await page.getByRole('button', { name: '退出登录', exact: true }).click();
    await expect(page.getByRole('button', { name: '登录', exact: true })).toBeVisible();
    assert.equal(await page.evaluate(() => IMSDK_HOST.client.currentUser), undefined);
    await page.evaluate(() => IMSDK_HOST.client.shutdown());
    assert.deepEqual(errors, []);
    report.checks.push('unconfigured login/registration with no technical form or requests', 'late ready restores registration and configured refresh interval', 'close clears interval and offers reopen', 'authenticated reopen shows conversations', 'visible logout returns login');
  }
  {
    const { page, errors } = await contextPage({ apiBaseUrl: 'http://invalid.example.test', serviceRealmId: 'entry', privacyConsentGranted: true });
    await page.goto(origin);
    await expect(page.getByRole('button', { name: '登录', exact: true })).toBeVisible();
    await expect(page.locator('#host-message')).toBeVisible();
    await page.evaluate(config => IMSDK_HOST.client.initialize(config), configuration);
    await expect(page.locator('#host-message')).toBeHidden();
    await page.evaluate(() => IMSDK_HOST.client.shutdown());
    assert.deepEqual(errors, []);
    report.checks.push('invalid host config keeps login; direct ready clears old host feedback');
  }
  {
    const { page, errors } = await contextPage(); await page.goto(origin + '/external.html');
    await page.evaluate(async ({ configuration, credentials }) => {
      const client = new IMSDK.ImSdkClient(); client.initialize(configuration); await client.authenticate(credentials);
      window.externalShutdownCalls = 0; window.externalInitializeCalls = 0;
      const stop = client.shutdown.bind(client), init = client.initialize.bind(client);
      client.shutdown = () => { externalShutdownCalls++; return stop(); };
      client.initialize = config => { externalInitializeCalls++; return init(config); };
      window.IMSDK_HOST_CLIENT = client; window.IMSDK_HOST_CONFIG = { apiBaseUrl: 'http://ignored.invalid' };
    }, { configuration, credentials });
    await page.addScriptTag({ content: bootstrap });
    await expect(page.getByRole('button', { name: '退出登录', exact: true })).toBeVisible();
    assert.equal(await page.getByPlaceholder('账号', { exact: true }).count(), 0);
    await page.evaluate(() => window.dispatchEvent(new PageTransitionEvent('pagehide', { persisted: false })));
    assert.deepEqual(await page.evaluate(() => ({ shutdown: externalShutdownCalls, initialize: externalInitializeCalls, authenticated: IMSDK_HOST_CLIENT.isAuthenticated })), { shutdown: 0, initialize: 0, authenticated: true });
    await page.evaluate(() => IMSDK_HOST_CLIENT.shutdown());
    assert.deepEqual(errors, []);
    report.checks.push('preauthenticated external client opens list without reinitialize; host retains ownership');
  }
  {
    const { page, errors } = await contextPage(); await page.goto(origin + '/external.html');
    await page.evaluate(async () => { const client = new IMSDK.ImSdkClient(); await client.shutdown(); window.IMSDK_HOST_CLIENT = client; });
    const orphan = await page.evaluate(() => {
      const target = document.createElement('div'); document.body.append(target); let code;
      try { IMSDK.mountMessenger(IMSDK_HOST_CLIENT, target); } catch (error) { code = error.code; }
      const nodes = target.childElementCount; target.remove(); return { code, nodes };
    });
    assert.deepEqual(orphan, { code: 'DISPOSED', nodes: 0 });
    await page.addScriptTag({ content: bootstrap });
    await expect(page.getByRole('button', { name: '打开聊天', exact: true })).toBeVisible();
    await expect(page.locator('#host-message')).toContainText('聊天服务暂未就绪');
    assert.deepEqual(errors, []);
    report.checks.push('disposed mount leaves no orphan DOM; plain entry provides friendly recovery');
  }
  for (const path of [resolve('example/index.html'), resolve(work, 'examples/plain-html/index.html')]) {
    const { page, calls, errors } = await contextPage(); await page.goto(pathToFileURL(path).href);
    await expect(page.getByRole('button', { name: '登录', exact: true })).toBeVisible();
    await page.getByRole('button', { name: '注册新账号', exact: true }).click();
    await expect(page.getByPlaceholder('昵称', { exact: true })).toBeVisible();
    assert.equal(calls.length, 0); assert.deepEqual(errors, []);
    await page.screenshot({ path: resolve(evidence, path.includes('file-handoff') ? 'file-handoff-registration.png' : 'file-example-registration.png'), fullPage: true });
    await page.evaluate(() => IMSDK_HOST.client.shutdown());
  }
  report.checks.push('file:// source example and standalone handoff show login and registration');
  report.passed = true;
} catch (error) { report.errors.push(error.stack ?? String(error)); report.passed = false; process.exitCode = 1; }
finally {
  for (const context of allContexts) await context.close();
  await browser.close(); await new Promise(r => server.close(r));
  await writeFile(resolve(evidence, 'entry-browser-report.json'), JSON.stringify(report, null, 2));
  console.log(JSON.stringify({ passed: report.passed, checks: report.checks.length, errors: report.errors, report: resolve(evidence, 'entry-browser-report.json') }));
}
