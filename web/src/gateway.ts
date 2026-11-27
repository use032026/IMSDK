import {
  HubConnectionBuilder,
  HubConnectionState,
  LogLevel,
  type HubConnection,
} from '@microsoft/signalr';
import type { ImSdkEvent } from './types.js';
import { string } from './protocol.js';

const RETRY_DELAYS = [1000, 2000, 5000, 10000, 30000] as const;
const PERSONAL_TENANT_ID = '11111111-1111-1111-1111-111111111111';
const SECURITY_EVENTS = [
  'auth.force_logout',
  'auth.session.revoked',
  'auth.device.kicked',
  'auth.password.changed',
  'auth.security.required',
  'auth.reuse.detected',
] as const;

/** Gateway events invalidate REST snapshots; they never become stored messages. */
export class ImSdkGateway {
  private readonly connection: HubConnection;
  private stopped = false;
  private securityHandled = false;
  private starting?: Promise<void>;
  private stopping?: Promise<void>;
  private retryTimer?: ReturnType<typeof setTimeout>;
  private heartbeatTimer?: ReturnType<typeof setInterval>;
  private retryCount = 0;
  private readonly invitations = new Set<string>();

  constructor(
    baseUrl: string,
    getToken: () => Promise<string>,
    private readonly emit: (event: ImSdkEvent) => void,
    private readonly onSecurityEvent: () => void,
    private readonly account: { spaceId: string; userId: string },
  ) {
    const url = new URL(baseUrl);
    if (url.protocol === 'wss:') url.protocol = 'https:';
    url.pathname = `${url.pathname.replace(/\/$/, '')}/ws/client`;
    this.connection = new HubConnectionBuilder()
      .withUrl(url.toString(), {
        accessTokenFactory: async () => {
          if (this.stopped) throw new Error('Gateway stopped');
          const token = await getToken();
          if (this.stopped) throw new Error('Gateway stopped');
          return token;
        },
        withCredentials: false,
      })
      .configureLogging(LogLevel.None)
      .withAutomaticReconnect([0, 2000, 5000, 10000, 30000])
      .build();

    for (const name of ['msg.new', 'msg.updated', 'msg.recalled', 'msg.read']) {
      this.connection.on(name, (...args: unknown[]) => {
        if (this.stopped) return;
        const conversationId = conversationFromEvent(args[0]);
        const detail = eventFields(args[0]);
        this.send({ type: 'messagesChanged',
          reset: name === 'msg.updated' || name === 'msg.recalled',
          ...(name === 'msg.read' ? { readReceipt: true } : {}),
          ...(conversationId ? { conversationId } : {}),
          ...(typeof detail.messageId === 'string' ? { messageId: detail.messageId } : {}),
          recalled: name === 'msg.recalled',
          silent: name === 'msg.recalled' && detail.silent === true });
        this.send({ type: 'conversationsChanged' });
        if (name === 'msg.new' && conversationId) this.notifyGroupInvitation(conversationId, detail);
      });
    }
    this.connection.on('conversation.deleted', (...args: unknown[]) => {
      if (this.stopped) return;
      const conversationId = conversationFromEvent(args[0]);
      this.send({ type: 'conversationDeleted', ...(conversationId ? { conversationId } : {}) });
      this.send({ type: 'conversationsChanged' });
      this.send({ type: 'messagesChanged', ...(conversationId ? { conversationId } : {}) });
    });
    for (const name of ['friend.request.created', 'friend.request.accepted', 'friend.request.rejected', 'friend.profile.updated']) {
      this.connection.on(name, () => this.send({ type: 'contactsChanged' }));
    }
    this.connection.on('group.settings.updated', (...args: unknown[]) => {
      this.send({ type: 'conversationPresentationChanged', conversationId: conversationFromEvent(args[0]) });
      this.send({ type: 'conversationsChanged' });
    });
    for (const name of [
      'customer_service.assigned',
      'temp_session.assigned',
      'temp_session.transferred',
      'customer_service.thread.transferred',
    ]) {
      this.connection.on(name, () => this.send({ type: 'customerServiceChanged' }));
    }
    for (const name of SECURITY_EVENTS) {
      this.connection.on(name, () => {
        if (this.stopped || this.securityHandled) return;
        this.securityHandled = true;
        // Stop is synchronous up to setting stopped/clearing timers, so even
        // another invocation in this transport batch cannot reactivate state.
        void this.stop();
        try { this.onSecurityEvent(); } catch { /* Host callbacks cannot revive a revoked connection. */ }
      });
    }

    this.connection.onreconnecting(() => {
      if (this.stopped) return;
      this.clearHeartbeat();
      this.send({ type: 'connectionChanged', state: 'reconnecting' });
    });
    this.connection.onreconnected(() => this.connected());
    this.connection.onclose(() => {
      if (this.stopped) return;
      this.clearHeartbeat();
      this.send({ type: 'connectionChanged', state: 'disconnected' });
      this.scheduleRetry();
    });
  }

  /** Initial negotiate failures are retried as well as established connections. */
  start(): Promise<void> {
    if (this.stopped) return Promise.resolve();
    if (this.starting) return this.starting;
    if (this.connection.state !== HubConnectionState.Disconnected) return Promise.resolve();
    if (this.retryTimer !== undefined) clearTimeout(this.retryTimer);
    this.retryTimer = undefined;
    const attempt = this.connect();
    this.starting = attempt.finally(() => {
      this.starting = undefined;
      if (!this.stopped && this.connection.state === HubConnectionState.Disconnected) this.scheduleRetry();
    });
    return this.starting;
  }

  /** Permanently retires this instance; repeated calls share the stop operation. */
  stop(): Promise<void> {
    this.stopped = true;
    if (this.retryTimer !== undefined) clearTimeout(this.retryTimer);
    this.retryTimer = undefined;
    this.clearHeartbeat();
    return this.stopping ??= this.connection.stop().catch(() => {
      // No credentials or transport diagnostics are exposed to the host.
    });
  }

  private async connect(): Promise<void> {
    this.send({ type: 'connectionChanged', state: this.retryCount ? 'reconnecting' : 'connecting' });
    if (this.stopped) return;
    try {
      await this.connection.start();
      if (this.stopped) { await this.connection.stop().catch(() => {}); return; }
      this.connected();
    } catch {
      this.send({ type: 'connectionChanged', state: 'disconnected' });
    }
  }

  private connected(): void {
    if (this.stopped) return;
    this.retryCount = 0;
    this.clearHeartbeat();
    this.heartbeatTimer = setInterval(() => {
      if (this.stopped || this.connection.state !== HubConnectionState.Connected) return;
      void this.connection.invoke('HeartbeatAsync', 'web').catch(() => {});
    }, 30000);
    this.send({ type: 'connectionChanged', state: 'connected' });
    // A fresh REST snapshot reconciles messages missed while disconnected.
    this.send({ type: 'conversationsChanged' });
    this.send({ type: 'messagesChanged', reconcile: true });
    this.send({ type: 'contactsChanged' });
  }

  private scheduleRetry(): void {
    if (this.stopped || this.starting || this.retryTimer !== undefined) return;
    const delay = RETRY_DELAYS[Math.min(this.retryCount++, RETRY_DELAYS.length - 1)]!;
    this.retryTimer = setTimeout(() => {
      this.retryTimer = undefined;
      void this.start();
    }, delay);
  }

  private clearHeartbeat(): void {
    if (this.heartbeatTimer !== undefined) clearInterval(this.heartbeatTimer);
    this.heartbeatTimer = undefined;
  }

  private notifyGroupInvitation(conversationId: string, detail: Record<string, unknown>): void {
    const { spaceId, userId } = this.account;
    const messageId = string(detail.messageId);
    const frameSpace = string(detail.spaceId);
    const tenantId = string(detail.tenantId);
    if (!messageId || detail.conversationType !== 'group' || detail.sourceType === 'widget' ||
        detail.isRecalled === true || (detail.messageType !== 'event' && detail.messageType !== 'system') ||
        (frameSpace && frameSpace !== spaceId) ||
        (tenantId && tenantId !== spaceId && !(spaceId === 'personal' && tenantId === PERSONAL_TENANT_ID))) return;
    let body = detail.body;
    if (typeof body === 'string') {
      try { body = JSON.parse(body); } catch { return; }
    }
    const event = record(record(body).event);
    const eventType = event.type ?? event.eventType;
    if ((eventType !== 'members_added' && eventType !== 'group_member_added') ||
        !Array.isArray(event.addedUserIds) || !event.addedUserIds.some(id => string(id) === userId)) return;
    const key = JSON.stringify([conversationId, messageId]);
    if (this.invitations.has(key)) return;
    this.invitations.add(key);
    this.send({ type: 'groupInvitationReceived', spaceId, conversationId, messageId });
  }

  private send(event: ImSdkEvent): void {
    if (this.stopped) return;
    try { this.emit(event); } catch { /* Listener failures must not break transport lifecycle. */ }
  }
}

function eventFields(value: unknown): Record<string, unknown> {
  const event = record(Array.isArray(value) ? value[0] : value);
  return { ...event, ...record(event.data ?? event.Data) };
}

function record(value: unknown): Record<string, unknown> {
  return value && typeof value === 'object' && !Array.isArray(value) ? value as Record<string, unknown> : {};
}

function conversationFromEvent(value: unknown): string | undefined {
  let item = Array.isArray(value) ? value[0] : value;
  if (!item || typeof item !== 'object') return undefined;
  const outer = item as Record<string, unknown>;
  item = outer.data ?? outer.Data ?? item;
  if (!item || typeof item !== 'object') return undefined;
  const row = item as Record<string, unknown>;
  const id = row.conversationId ?? row.ConversationId;
  return typeof id === 'string' && id.trim() ? id.trim() : undefined;
}
