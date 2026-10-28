export interface ImSdkPasswordLoginConfig {
  space: 'personal' | 'tenant';
  loginType: 'lpp_id' | 'login_name';
  tenantCode?: string;
}
export interface ImSdkConfig {
  apiBaseUrl: string;
  gatewayBaseUrl?: string;
  serviceRealmId: string;
  privacyConsentGranted: boolean;
  passwordLogin?: ImSdkPasswordLoginConfig;
  /** 30 seconds by default. */
  requestTimeoutMs?: number;
  /** SignalR enabled by default; REST still works when temporarily offline. */
  realtime?: boolean;
  /** UI reconciliation interval, default 15 seconds, minimum 5 seconds. */
  pollIntervalMs?: number;
}
export interface ImSdkCredentials {
  platformUserId: string;
  userId: string;
  spaceId: string;
  accessToken: string;
  refreshToken: string;
  expiresAt: string;
  platformToken?: string;
  platformRefreshToken?: string;
  deviceSessionToken?: string;
}
export interface LoginRequest {
  account: string;
  password: string;
  captchaToken?: string;
  captchaAnswer?: string;
}
export interface CaptchaChallenge { token: string; question: string }
export type RegistrationChannel = 'sms' | 'email';
export interface RegistrationVerificationSettings {
  smsEnabled: boolean; emailEnabled: boolean; smsRequired: boolean; emailRequired: boolean;
}
export interface RegistrationCodeRequest {
  channel: RegistrationChannel; identifier: string; captchaToken?: string; captchaAnswer?: string;
}
export interface RegistrationRequest extends RegistrationCodeRequest {
  displayName: string; password: string; verificationCode?: string;
}
export interface ConversationTarget {
  conversationId: string;
  type: 'direct' | 'group';
  title?: string;
}
export interface Conversation extends ConversationTarget {
  title: string;
  unreadCount: number;
  peerUserId?: string;
  lastMessage?: string;
  lastMessageAt?: string;
}
export interface ConversationPage { items: Conversation[]; nextCursor?: string }
export interface Contact { userId: string; displayName: string }
export interface UserSearchResult extends Contact { isFriend?: boolean; lppId?: string }
export type FriendRequestStatus = 'pending' | 'accepted' | 'rejected' | 'cancelled' | 'unknown';
export interface FriendRequestSubmission { requestId: string; status: 'pending' | 'accepted' }
export interface FriendRequest {
  requestId: string; fromUserId: string; fromDisplayName: string;
  toUserId: string; toDisplayName: string; message?: string; status: FriendRequestStatus;
}
export interface CreateGroupRequest { title: string; memberUserIds?: string[] }
export interface Message {
  messageId: string;
  clientMessageId?: string;
  conversationId: string;
  senderUserId: string;
  senderName?: string;
  type: string;
  text: string;
  seq: number;
  sentAt: string;
  isSelf: boolean;
}
export type CustomerServiceRequest =
  | { entry: 'currentTenant'; serviceAccountId?: never }
  | { entry?: 'serviceAccount'; serviceAccountId: string; locale?: string; category?: string; sourceUrl?: string };
export interface CustomerServiceSession {
  threadId: string;
  status: 'queued' | 'active' | 'unknown';
  conversationId?: string;
  staffUserId?: string;
  staffDisplayName?: string;
  canOpenConversation: boolean;
}
export interface ImSdkEvent { type: string; code?: string; [key: string]: unknown }
export interface PageOptions { cursor?: string; limit?: number }
export interface MessagePageOptions { beforeSeq?: number; limit?: number }

/** Stable error codes, without raw backend payloads, tokens or passwords. */
export class ImSdkError extends Error {
  constructor(public readonly code: string, message: string, public readonly status?: number) {
    super(message);
    this.name = 'ImSdkError';
  }
}
