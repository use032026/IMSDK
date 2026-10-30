import { sdkUiLocales } from './generated/l10n/sdk_catalog.js';
import { type ImSdkPresentation } from './types.js';
export type UiLocale = 'zh-CN' | (typeof sdkUiLocales)[number];
/** Validate both fields before the caller commits either one. */
export declare function normalizePresentation(value: ImSdkPresentation, current?: Readonly<ImSdkPresentation>): Required<ImSdkPresentation>;
export declare function resolvedLocale(locale?: string, languages?: readonly string[]): UiLocale;
export declare function hasUiString(source: string): boolean;
export declare function translateUi(source: string, locale: UiLocale, values?: Record<string, string | number>): string;
export declare function formatTimestamp(value: string, locale: UiLocale): string;
