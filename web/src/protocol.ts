import { ImSdkError, type Conversation, type Message } from './types.js';

export type Json = Record<string, unknown>;
export function createClientMessageId(): string {
  if (typeof crypto.randomUUID === 'function') return crypto.randomUUID();
  const bytes = crypto.getRandomValues(new Uint8Array(16));
  bytes[6] = (bytes[6]! & 15) | 64;
  bytes[8] = (bytes[8]! & 63) | 128;
  const hex = [...bytes].map(byte => byte.toString(16).padStart(2, '0')).join('');
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}
export function object(value: unknown): Json {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    throw new ImSdkError('INVALID_RESPONSE', '服务响应格式无效');
  }
  return value as Json;
}
export function string(value: unknown): string { return typeof value === 'string' ? value.trim() : ''; }
export function required(value: unknown, field: string): string {
  const result = string(value);
  if (!result) throw new ImSdkError('INVALID_ARGUMENT', `${field}不能为空`);
  return result;
}
export function sequence(value: unknown): number {
  const number = Number(value);
  return Number.isSafeInteger(number) && number >= 0 ? number : 0;
}
export function conversation(value: unknown): Conversation {
  const row = object(value);
  if (row.conversationType !== 'direct' && row.conversationType !== 'group') {
    throw new ImSdkError('UNSUPPORTED_CONVERSATION', '当前 Web SDK 支持单聊和群聊');
  }
  const last = row.lastMessage && typeof row.lastMessage === 'object' ? object(row.lastMessage) : {};
  return {
    conversationId: required(row.conversationId, 'conversationId'), type: row.conversationType,
    title: string(row.title) || (row.conversationType === 'group' ? '群聊' : '聊天'),
    unreadCount: sequence(row.unreadCount), peerUserId: string(row.peerUserId) || undefined,
    lastMessage: string(last.preview) || undefined,
    lastMessageAt: string(row.lastActivityAt) || string(last.sentAt) || undefined,
  };
}
export function message(value: unknown, conversationId: string, userId: string): Message {
  const row = object(value);
  let body = row.body;
  if (typeof body === 'string') { try { body = JSON.parse(body); } catch { body = {}; } }
  const content = body && typeof body === 'object' ? object(body) : {};
  const type = row.isRecalled === true || row.status === 'recalled' ? 'recalled' : string(row.messageType) || 'unknown';
  const senderUserId = string(row.senderUserId) || string(row.senderId) || string(row.fromUserId) || string(row.userId);
  return {
    messageId: required(row.messageId, 'messageId'), clientMessageId: string(row.clientMsgId) || undefined,
    conversationId: string(row.conversationId) || conversationId,
    senderUserId, senderName: string(row.senderDisplayName) || string(row.senderName) || undefined,
    type, text: type === 'text' && typeof content.text === 'string' ? content.text : `[${({ image: '图片', video: '视频', audio: '语音', file: '文件', system: '系统消息', recalled: '消息已撤回' } as Json)[type] || '暂不支持的消息'}]`,
    seq: sequence(row.conversationSeq ?? row.seq), sentAt: string(row.sentAt) || string(row.serverTime),
    isSelf: row.isSelf === true || row.isMine === true || ['out', 'outgoing', 'sent', 'self'].includes(string(row.direction)) || (!!senderUserId && senderUserId === userId),
  };
}

/** Claims are used only after profile/me accepts the bearer; never as verification. */
export function acceptedClaims(token: string): Json {
  try {
    const encoded = token.split('.')[1];
    if (!encoded) return {};
    const bytes = Uint8Array.from(atob(encoded.replace(/-/g, '+').replace(/_/g, '/')), c => c.charCodeAt(0));
    return object(JSON.parse(new TextDecoder().decode(bytes)));
  } catch { return {}; }
}
