import assert from 'node:assert/strict';
import test from 'node:test';
import { build } from 'esbuild';

// Exercise the actual presentation module and generated dictionary in memory;
// these checks do not start a browser, SDK session, or backend request.
const bundled = await build({
  entryPoints: ['src/presentation.ts'], bundle: true, write: false,
  format: 'esm', platform: 'node', target: 'node20',
});
const presentation = await import(`data:text/javascript;base64,${Buffer.from(bundled.outputFiles[0].text).toString('base64')}`);

test('SDK Web chrome keeps its six-language wording after extraction', () => {
  const expected = { 'zh-CN': '客服', 'zh-TW': '客服', en: 'Support', ja: 'サポート', ko: '고객 지원', vi: 'Hỗ trợ' };
  for (const [locale, value] of Object.entries(expected)) {
    assert.equal(presentation.translateUi('客服', locale), value);
  }
});

test('Web placeholders preserve host values and missing-token behavior', () => {
  assert.equal(presentation.translateUi('与{name}聊天', 'en', { name: 'Alex' }), 'Chat with Alex');
  assert.equal(presentation.translateUi('{name}，{count} 条未读消息', 'en', { name: 'Alex', count: 3 }), 'Alex, 3 unread messages');
  assert.equal(presentation.translateUi('邀请{name}', 'en'), 'Invite {name}');
});

test('dictionary membership does not claim user strings or inherited properties', () => {
  assert.equal(presentation.hasUiString('客服'), true);
  assert.equal(presentation.hasUiString('constructor'), false);
  assert.equal(presentation.hasUiString('Host-provided title'), false);
  assert.equal(presentation.translateUi('Host-provided title', 'en'), 'Host-provided title');
});

test('locale aliases and system fallback retain the existing contract', () => {
  assert.equal(presentation.resolvedLocale('zh_Hant_HK'), 'zh-TW');
  assert.equal(presentation.resolvedLocale('system', ['it-IT', 'ja-JP']), 'it');
  assert.equal(presentation.resolvedLocale('system', ['xx-XX', 'ja-JP']), 'ja');
  assert.equal(presentation.resolvedLocale('system', ['xx-XX']), 'zh-CN');
});
