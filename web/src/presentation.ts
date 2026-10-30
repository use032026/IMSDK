import { sdkUiCatalog as catalog, sdkUiLocales } from './generated/l10n/sdk_catalog.js';
import { ImSdkError, type ImSdkPresentation, type ImSdkThemeMode } from './types.js';

export type UiLocale = 'zh-CN' | (typeof sdkUiLocales)[number];
const columns: readonly string[] = sdkUiLocales;

function supportedLocale(value: string): UiLocale | undefined {
  let canonical: string;
  try {
    const alias = value.trim().replace(/_/g, '-').replace(/^pt(br|pt)$/i, 'pt-$1');
    canonical = Intl.getCanonicalLocales(alias)[0] ?? '';
  }
  catch { return undefined; }
  if (!/^[a-z]{2,3}(?:-[a-z]{4})?(?:-[a-z]{2}|-\d{3})?$/i.test(canonical)) return undefined;
  const parts = canonical.toLowerCase().split('-');
  const language = ({ no: 'nb', tl: 'fil', in: 'id' } as Record<string, string>)[parts[0] ?? ''] ?? parts[0];
  const script = parts.slice(1).find(part => /^[a-z]{4}$/.test(part));
  const region = parts.slice(1).find(part => /^[a-z]{2}$|^\d{3}$/.test(part));
  if (language === 'zh') {
    if (region && !['cn', 'sg', 'tw', 'hk', 'mo'].includes(region)) return undefined;
    if (parts.includes('hans')) return 'zh-CN';
    if (parts.includes('hant')) return 'zh-TW';
    if (script) return undefined;
    return parts.some(part => ['tw', 'hk', 'mo'].includes(part)) ? 'zh-TW' : 'zh-CN';
  }
  const scripts: Record<string, string> = {
    en: 'latn', ja: 'jpan', ko: 'kore', vi: 'latn', ar: 'arab', bg: 'cyrl', cs: 'latn', da: 'latn', de: 'latn', el: 'grek',
    es: 'latn', fi: 'latn', fil: 'latn', fr: 'latn', hi: 'deva', hr: 'latn', hu: 'latn', id: 'latn', it: 'latn', ms: 'latn',
    nb: 'latn', nl: 'latn', pl: 'latn', pt: 'latn', ro: 'latn', ru: 'cyrl', si: 'sinh', sk: 'latn', sv: 'latn', th: 'thai', tr: 'latn', uk: 'cyrl',
  };
  if (!language || !scripts[language] || (script && script !== scripts[language])) return undefined;
  const selected = language === 'pt' ? region === 'pt' ? 'pt-PT' : 'pt-BR' : language;
  return columns.includes(selected) ? selected as UiLocale : undefined;
}

/** Validate both fields before the caller commits either one. */
export function normalizePresentation(value: ImSdkPresentation, current?: Readonly<ImSdkPresentation>): Required<ImSdkPresentation> {
  if (!value || typeof value !== 'object' || Array.isArray(value)) throw new ImSdkError('INVALID_PRESENTATION', '显示设置无效');
  const suppliedTheme = value.themeMode === undefined ? current?.themeMode ?? 'system' : value.themeMode;
  const themeMode = typeof suppliedTheme === 'string' ? suppliedTheme.trim().toLowerCase() : '';
  if (!['system', 'light', 'dark'].includes(themeMode)) throw new ImSdkError('INVALID_PRESENTATION', '显示设置无效');
  const supplied = value.locale === undefined ? current?.locale ?? 'zh-CN' : value.locale;
  if (typeof supplied !== 'string' || !supplied.trim()) throw new ImSdkError('INVALID_PRESENTATION', '显示设置无效');
  const locale = supplied.trim().toLowerCase() === 'system' ? 'system' : supportedLocale(supplied);
  if (!locale) throw new ImSdkError('INVALID_PRESENTATION', '显示设置无效');
  return { themeMode: themeMode as ImSdkThemeMode, locale };
}

export function resolvedLocale(locale = 'zh-CN', languages?: readonly string[]): UiLocale {
  if (locale !== 'system') return supportedLocale(locale) ?? 'zh-CN';
  const candidates = languages ?? (typeof navigator === 'undefined' ? [] : navigator.languages?.length ? navigator.languages : [navigator.language]);
  for (const value of candidates) { const supported = supportedLocale(value); if (supported) return supported; }
  return 'zh-CN';
}

// Keys describe SDK chrome only. User names, message bodies and server content
// are always passed through the view's raw-text path, even when they equal a key.

export function hasUiString(source: string): boolean { return Object.prototype.hasOwnProperty.call(catalog, source); }
export function translateUi(source: string, locale: UiLocale, values: Record<string, string | number> = {}): string {
  const index = columns.indexOf(locale);
  const translated = index < 0 ? source : catalog[source]?.[index] ?? source;
  return translated.replace(/\{(\w+)\}/g, (match, key: string) => Object.prototype.hasOwnProperty.call(values, key) ? String(values[key]) : match);
}

export function formatTimestamp(value: string, locale: UiLocale): string {
  const date = new Date(value);
  if (!Number.isFinite(date.getTime())) return '';
  const today = new Date();
  return date.toDateString() === today.toDateString()
    ? date.toLocaleTimeString(locale, { hour: '2-digit', minute: '2-digit' })
    : date.toLocaleDateString(locale, { month: 'short', day: 'numeric' });
}
