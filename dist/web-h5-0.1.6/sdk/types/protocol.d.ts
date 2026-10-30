import { type Conversation, type Message } from './types.js';
export type Json = Record<string, unknown>;
export declare function createClientMessageId(): string;
export declare function object(value: unknown): Json;
export declare function string(value: unknown): string;
export declare function required(value: unknown, field: string): string;
export declare function sequence(value: unknown): number;
export declare function conversation(value: unknown): Conversation;
export declare function message(value: unknown, conversationId: string, userId: string): Message;
/** Claims are used only after profile/me accepts the bearer; never as verification. */
export declare function acceptedClaims(token: string): Json;
