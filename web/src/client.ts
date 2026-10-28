import {
  ImSdkError, type ImSdkConfig, type ImSdkCredentials, type ImSdkEvent,
  type LoginRequest, type CaptchaChallenge, type Conversation, type ConversationPage,
  type ConversationTarget, type Message, type PageOptions, type MessagePageOptions,
  type CustomerServiceRequest, type CustomerServiceSession, type Contact,
} from './types.js';
import { object, required, string, conversation, message, acceptedClaims, createClientMessageId, type Json } from './protocol.js';
import { ImSdkGateway } from './gateway.js';

const API = '/api/client/v1';
const PLATFORM = '/api/platform/v1';

/** One account per instance. No global state, persistent credentials or automatic sends. */
export class ImSdkClient {
  private settings?: Readonly<ImSdkConfig>;
  private credentials?: ImSdkCredentials;
  private disposed = false;
  private revision = 0;
  private listeners = new Set<(event: ImSdkEvent) => void>();
  private requests = new Set<AbortController>();
  private refreshTask?: Promise<void>;
  private gateway?: ImSdkGateway;
  private stopping = new Set<Promise<void>>();

  get isInitialized(): boolean { return !!this.settings && !this.disposed; }
  get isAuthenticated(): boolean { return this.isInitialized && !!this.credentials; }
  get sessionRevision(): number { return this.revision; }
  get config(): ImSdkConfig | undefined {
    return this.settings ? { ...this.settings, passwordLogin: this.settings.passwordLogin && { ...this.settings.passwordLogin } } : undefined;
  }
  get currentUser(): { userId: string; platformUserId: string; spaceId: string } | undefined {
    const c = this.credentials;
    return c ? { userId: c.userId, platformUserId: c.platformUserId, spaceId: c.spaceId } : undefined;
  }

  on(listener: (event: ImSdkEvent) => void): () => void {
    if (this.disposed) throw new ImSdkError('DISPOSED', 'SDK已释放');
    this.listeners.add(listener);
    return () => { this.listeners.delete(listener); };
  }
  private emit(event: ImSdkEvent): void {
    for (const listener of [...this.listeners]) {
      try { listener(Object.freeze({ ...event })); } catch { /* Host callbacks cannot break lifecycle. */ }
    }
  }

  initialize(config: ImSdkConfig): void {
    if (this.disposed) throw new ImSdkError('DISPOSED', 'SDK已释放');
    if (this.settings) throw new ImSdkError('CONFIG_CONFLICT', '请为新配置创建新的SDK实例');
    if (config.privacyConsentGranted !== true) throw new ImSdkError('CONSENT_REQUIRED', '宿主需先取得用户同意');
    const endpoint = (raw: string, gateway = false): string => {
      try {
        const url = new URL(raw);
        if (!(gateway ? ['https:', 'wss:'] : ['https:']).includes(url.protocol) ||
            !url.hostname || url.username || url.password || url.search || url.hash) throw new Error();
        return url.href.replace(/\/+$/, '');
      } catch { throw new ImSdkError('INVALID_CONFIG', gateway ? 'gatewayBaseUrl需要HTTPS/WSS地址' : 'apiBaseUrl需要HTTPS地址'); }
    };
    const login = config.passwordLogin ?? { space: 'personal', loginType: 'lpp_id' };
    if (!['personal', 'tenant'].includes(login.space) || !['lpp_id', 'login_name'].includes(login.loginType) ||
        (login.space === 'personal' && (login.loginType !== 'lpp_id' || login.tenantCode !== undefined)) ||
        (login.space === 'tenant' && !string(login.tenantCode))) throw new ImSdkError('INVALID_CONFIG', '账号空间或企业登录配置无效');
    for (const [key, value, min] of [
      ['requestTimeoutMs', config.requestTimeoutMs, 100], ['pollIntervalMs', config.pollIntervalMs, 5000],
    ] as const) {
      if (value !== undefined && (!Number.isFinite(value) || value < min || value > 300000)) {
        throw new ImSdkError('INVALID_CONFIG', `${key}超出允许范围`);
      }
    }
    this.settings = Object.freeze({ ...config, apiBaseUrl: endpoint(config.apiBaseUrl),
      gatewayBaseUrl: config.gatewayBaseUrl ? endpoint(config.gatewayBaseUrl, true) : undefined,
      serviceRealmId: required(config.serviceRealmId, 'serviceRealmId'),
      passwordLogin: Object.freeze({ ...login }), requestTimeoutMs: config.requestTimeoutMs ?? 30000,
      pollIntervalMs: config.pollIntervalMs ?? 15000 });
    this.emit({ type: 'ready' });
  }

  async requestLoginCaptcha(): Promise<CaptchaChallenge> {
    this.requireInitialized();
    const data = object(await this.raw(`${API}/auth/captcha/generate`, 'POST'));
    return { token: required(data.token, 'captcha token'), question: required(data.question ?? data.captchaQuestion, 'captcha question') };
  }

  async loginWithPassword(request: LoginRequest): Promise<void> {
    const config = this.requireInitialized();
    const account = required(request.account, '账号');
    if (typeof request.password !== 'string' || !request.password) throw new ImSdkError('INVALID_ARGUMENT', '密码不能为空');
    if ((request.captchaToken !== undefined || request.captchaAnswer !== undefined) &&
        (!string(request.captchaToken) || !string(request.captchaAnswer))) throw new ImSdkError('INVALID_ARGUMENT', '请完成安全验证');
    const epoch = this.retireSession();
    const login = config.passwordLogin!;
    const captcha = request.captchaToken ? { captchaToken: request.captchaToken, captchaAnswer: request.captchaAnswer } : {};
    try {
      let data: Json;
      let platform: Json = {};
      let expectedSpace: string | undefined;
      if (login.loginType === 'login_name') {
        data = object(await this.raw(`${API}/auth/login`, 'POST', {
          loginName: account, password: request.password, loginType: login.loginType,
          tenantCode: login.tenantCode, deviceType: 'web', ...captcha,
        }, undefined, epoch));
      } else {
        platform = object(await this.raw(`${PLATFORM}/auth/login`, 'POST', {
          identifier: account, password: request.password, loginType: login.loginType, ...captcha,
        }, undefined, epoch));
        const platformToken = required(platform.platformToken, 'platformToken');
        if (login.space === 'personal') {
          expectedSpace = 'personal';
          data = object(await this.raw(`${PLATFORM}/auth/select-personal-space`, 'POST', undefined, platformToken, epoch));
        } else {
          const tenants = await this.raw(`${PLATFORM}/my/tenants`, 'GET', undefined, platformToken, epoch);
          if (!Array.isArray(tenants)) throw new ImSdkError('INVALID_RESPONSE', '企业列表格式无效');
          const matched = tenants.map(object).filter(t => string(t.tenantCode) === login.tenantCode);
          if (matched.length !== 1) throw new ImSdkError('AUTH_CONTEXT_REQUIRED', '账号无法进入应用配置的企业');
          expectedSpace = required(matched[0]!.tenantId, 'tenantId');
          data = object(await this.raw(`${PLATFORM}/auth/select-tenant`, 'POST', { tenantId: expectedSpace }, platformToken, epoch));
        }
      }
      const credentials = this.parseCredentials(data, undefined, expectedSpace);
      credentials.platformToken = string(platform.platformToken) || undefined;
      credentials.platformRefreshToken = string(platform.platformRefreshToken) || undefined;
      credentials.deviceSessionToken = platform.deviceSession ? string(object(platform.deviceSession).deviceSessionToken) || undefined : undefined;
      if (!credentials.platformUserId) credentials.platformUserId = string(platform.platformUserId);
      await this.verifyIdentity(credentials, epoch);
      this.activate(credentials, epoch);
    } catch (error) {
      if (epoch === this.revision) this.emit({ type: 'authenticationFailed', code: this.failure(error).code });
      throw this.failure(error);
    }
  }

  async authenticate(credentials: ImSdkCredentials): Promise<void> {
    this.requireInitialized();
    const copy = { ...credentials };
    for (const field of ['userId', 'platformUserId', 'spaceId', 'accessToken', 'refreshToken'] as const) required(copy[field], field);
    if (!Number.isFinite(Date.parse(copy.expiresAt)) || Date.parse(copy.expiresAt) <= Date.now()) {
      throw new ImSdkError('CREDENTIALS_EXPIRED', '请向宿主后端获取有效IM凭证');
    }
    const epoch = this.retireSession();
    await this.verifyIdentity(copy, epoch);
    this.activate(copy, epoch);
  }

  async listConversations(options: PageOptions = {}): Promise<ConversationPage> {
    const query = new URLSearchParams({ limit: String(this.limit(options.limit)) });
    if (options.cursor) query.set('cursor', options.cursor);
    const data = object(await this.authorized(`${API}/conversations?${query}`));
    if (!Array.isArray(data.items)) throw new ImSdkError('INVALID_RESPONSE', '会话列表格式无效');
    // Temporary service sessions are outside this public direct/group API.
    return { items: data.items.filter(x => ['direct', 'group'].includes(string(object(x).conversationType))).map(conversation),
      nextCursor: string(data.nextCursor) || undefined };
  }

  async getConversation(id: string): Promise<Conversation> {
    // Resolve through the authoritative paginated list; no undocumented detail endpoint.
    let cursor: string | undefined;
    const seen = new Set<string>();
    do {
      const page = await this.listConversations({ cursor, limit: 100 });
      const found = page.items.find(row => row.conversationId === required(id, 'conversationId'));
      if (found) return found;
      cursor = page.nextCursor;
      if (cursor && seen.has(cursor)) break;
      if (cursor) seen.add(cursor);
    } while (cursor);
    throw new ImSdkError('CONVERSATION_NOT_FOUND', '会话不存在或当前账号无权访问');
  }

  async listMessages(target: ConversationTarget, options: MessagePageOptions = {}): Promise<Message[]> {
    const base = this.targetPath(target);
    const userId = this.requireSession().userId;
    const query = new URLSearchParams({ limit: String(this.limit(options.limit)) });
    if (options.beforeSeq !== undefined) {
      this.validateSeq(options.beforeSeq); query.set('beforeSeq', String(options.beforeSeq));
    }
    const data = await this.authorized(`${base}/messages?${query}`);
    if (!Array.isArray(data)) throw new ImSdkError('INVALID_RESPONSE', '消息列表格式无效');
    return data.map(row => message(row, target.conversationId, userId)).sort((a, b) => a.seq - b.seq);
  }

  async sendText(target: ConversationTarget, text: string, options: { clientMessageId?: string } = {}): Promise<Message> {
    const base = this.targetPath(target);
    const userId = this.requireSession().userId;
    if (typeof text !== 'string' || !text.trim()) throw new ImSdkError('INVALID_ARGUMENT', '消息不能为空');
    if (text.length > 10000) throw new ImSdkError('INVALID_ARGUMENT', '消息不能超过10000字');
    const clientMsgId = options.clientMessageId === undefined ? createClientMessageId() : required(options.clientMessageId, 'clientMessageId');
    const result = object(await this.authorized(`${base}/messages`, 'POST', {
      clientMsgId, messageType: 'text', body: { text }, mentions: [],
    }));
    const sent = message({ ...result, clientMsgId, senderUserId: userId, isSelf: true, messageType: 'text', body: { text } }, target.conversationId, userId);
    this.emit({ type: 'messagesChanged', conversationId: target.conversationId });
    this.emit({ type: 'conversationsChanged' });
    return sent;
  }

  async markRead(target: ConversationTarget, seq: number): Promise<void> {
    this.validateSeq(seq);
    await this.authorized(`${this.targetPath(target)}/read`, 'POST', { readSeq: seq });
  }

  async createDirectConversation(peerUserId: string): Promise<Conversation> {
    const peer = required(peerUserId, 'peerUserId');
    const data = object(await this.authorized(`${API}/direct-chats`, 'POST', { peerUserId: peer }));
    const id = required(data.conversationId ?? data.chatId, 'conversationId');
    this.emit({ type: 'conversationsChanged' });
    return { conversationId: id, type: 'direct', title: string(data.title) || '聊天', peerUserId: peer, unreadCount: 0 };
  }

  async listContacts(): Promise<Contact[]> {
    const data = await this.authorized(`${API}/friends`);
    if (!Array.isArray(data)) throw new ImSdkError('INVALID_RESPONSE', '联系人列表格式无效');
    return data.map(value => {
      const row = object(value);
      return { userId: required(row.friendUserId ?? row.userId, 'userId'),
        displayName: string(row.remarkName) || string(row.displayName) || string(row.name) || '联系人' };
    });
  }

  async requestCustomerService(request: CustomerServiceRequest): Promise<CustomerServiceSession> {
    const current = request.entry === 'currentTenant';
    if ((current && 'serviceAccountId' in request && request.serviceAccountId !== undefined) ||
        (!current && request.entry !== undefined && request.entry !== 'serviceAccount')) throw new ImSdkError('INVALID_ARGUMENT', '客服入口配置冲突');
    const data = object(await this.authorized(current ? `${API}/official-account/contact-service` : `${API}/customer-service/im-direct/contact-brand`, 'POST',
      current ? undefined : { serviceAccountId: required(request.serviceAccountId, 'serviceAccountId'), priority: 0,
        locale: request.locale, category: request.category, sourceUrl: request.sourceUrl }));
    const rawStatus = string(current ? data.status : data.threadStatus).toLowerCase();
    const status = rawStatus === 'active' ? 'active' : (rawStatus === 'queued' || (!current && rawStatus === 'pending')) ? 'queued' : 'unknown';
    const conversationId = string(data.conversationId) || undefined;
    const session: CustomerServiceSession = { threadId: required(data.threadId, 'threadId'), status, conversationId,
      staffUserId: string(data.staffUserId) || undefined, staffDisplayName: string(data.staffDisplayName) || undefined,
      canOpenConversation: status === 'active' && !!conversationId };
    this.emit({ type: 'customerServiceChanged', ...session });
    return session;
  }

  async logout(): Promise<void> {
    this.requireInitialized();
    this.retireSession();
    this.emit({ type: 'loggedOut' });
    await Promise.all([...this.stopping]);
  }

  async shutdown(): Promise<void> {
    if (this.disposed) { await Promise.all([...this.stopping]); return; }
    this.retireSession();
    this.disposed = true;
    this.emit({ type: 'shutdown' });
    this.listeners.clear();
    await Promise.all([...this.stopping]);
  }

  private retireSession(): number {
    const epoch = ++this.revision;
    this.credentials = undefined;
    this.refreshTask = undefined;
    for (const request of this.requests) request.abort();
    this.requests.clear();
    const gateway = this.gateway;
    this.gateway = undefined;
    if (gateway) {
      const task = gateway.stop().catch(() => {}).finally(() => { this.stopping.delete(task); });
      this.stopping.add(task);
    }
    this.emit({ type: 'sessionChanging' });
    return epoch;
  }

  private activate(credentials: ImSdkCredentials, epoch: number): void {
    this.checkEpoch(epoch);
    this.credentials = credentials;
    this.emit({ type: 'authenticated', spaceId: credentials.spaceId });
    if (this.settings!.realtime !== false && this.isAuthenticated && this.revision === epoch) {
      this.gateway = new ImSdkGateway(this.settings!.gatewayBaseUrl ?? this.settings!.apiBaseUrl,
        async () => { this.checkEpoch(epoch); return this.accessToken(epoch); },
        event => { if (this.revision === epoch && this.isAuthenticated) this.emit(event); },
        () => { if (this.revision === epoch) this.expireSession(); });
      void this.gateway.start();
    }
  }

  private expireSession(): void {
    this.retireSession();
    this.emit({ type: 'authenticationRequired', code: 'SESSION_EXPIRED' });
  }
  private async verifyIdentity(credentials: ImSdkCredentials, epoch: number): Promise<void> {
    const profile = object(await this.raw(`${API}/profile/me`, 'GET', undefined, credentials.accessToken, epoch));
    const claims = acceptedClaims(credentials.accessToken);
    const claimUser = string(claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']);
    const platformId = string(profile.platformUserId) || (claimUser === string(profile.userId) ? string(claims.platform_user_id) : '');
    if (!platformId || string(profile.userId) !== credentials.userId || (credentials.platformUserId && platformId !== credentials.platformUserId)) {
      throw new ImSdkError('AUTH_EXTERNAL_IDENTITY_MISMATCH', 'IM凭证与服务端身份不匹配');
    }
    const context = profile.spaceContext ? object(profile.spaceContext) : {};
    const serverSpace = context.spaceType === 1 ? 'personal' : string(profile.tenantId) || string(context.tenantId) || string(claims.tenant_id);
    if (serverSpace && serverSpace !== credentials.spaceId) throw new ImSdkError('AUTH_EXTERNAL_IDENTITY_MISMATCH', 'IM凭证与空间不匹配');
    credentials.platformUserId = platformId;
  }

  private parseCredentials(data: Json, previous?: ImSdkCredentials, expectedSpace?: string): ImSdkCredentials {
    const context = data.spaceContext ? object(data.spaceContext) : {};
    const spaceId = context.spaceType === 1 ? 'personal' : string(data.tenantId) || string(data.spaceId) || expectedSpace || previous?.spaceId || '';
    if (expectedSpace && spaceId !== expectedSpace) throw new ImSdkError('AUTH_CONTEXT_REQUIRED', '登录空间与应用配置不匹配');
    const expiresIn = Number(data.expiresIn ?? 3600);
    if (!Number.isFinite(expiresIn) || expiresIn <= 0) throw new ImSdkError('INVALID_RESPONSE', '凭证有效期无效');
    return { ...previous, userId: string(data.userId) || previous?.userId || '',
      platformUserId: string(data.platformUserId) || previous?.platformUserId || '',
      spaceId: required(spaceId, 'spaceId'), accessToken: required(data.accessToken, 'accessToken'),
      refreshToken: required(data.refreshToken ?? previous?.refreshToken, 'refreshToken'),
      expiresAt: new Date(Date.now() + expiresIn * 1000).toISOString() };
  }

  private async refresh(epoch: number): Promise<void> {
    this.checkEpoch(epoch);
    if (!this.refreshTask) {
      const previous = this.requireSession();
      const task = (async () => {
        try {
          const data = object(await this.raw(`${API}/auth/refresh`, 'POST', { refreshToken: previous.refreshToken }, undefined, epoch));
          const next = this.parseCredentials(data, previous, previous.spaceId);
          if (next.userId !== previous.userId || next.platformUserId !== previous.platformUserId) throw new ImSdkError('AUTH_EXTERNAL_IDENTITY_MISMATCH', '刷新凭证身份不匹配');
          await this.verifyIdentity(next, epoch);
          this.checkEpoch(epoch);
          this.credentials = next;
        } catch (error) {
          const failure = this.failure(error);
          if (this.revision === epoch && (failure.status === 401 || failure.status === 403 ||
              /^(AUTH_|TOKEN_|REFRESH_TOKEN_|SESSION_)/.test(failure.code))) this.expireSession();
          throw failure;
        }
      })();
      this.refreshTask = task;
      void task.finally(() => { if (this.refreshTask === task) this.refreshTask = undefined; }).catch(() => {});
    }
    await this.refreshTask;
  }

  private async accessToken(epoch: number): Promise<string> {
    const session = this.requireSession();
    if (Date.parse(session.expiresAt) - Date.now() < 30000) await this.refresh(epoch);
    this.checkEpoch(epoch);
    return this.requireSession().accessToken;
  }

  private async authorized(path: string, method = 'GET', body?: unknown): Promise<unknown> {
    this.requireSession();
    const epoch = this.revision;
    const token = await this.accessToken(epoch);
    try { return await this.raw(path, method, body, token, epoch); }
    catch (error) {
      if (!(error instanceof ImSdkError) || error.status !== 401) throw error;
      this.checkEpoch(epoch);
      if (this.requireSession().accessToken === token) await this.refresh(epoch);
      this.checkEpoch(epoch);
      try { return await this.raw(path, method, body, this.requireSession().accessToken, epoch); }
      catch (retryError) {
        if (retryError instanceof ImSdkError && retryError.status === 401 && this.revision === epoch) this.expireSession();
        throw retryError;
      }
    }
  }

  private async raw(path: string, method: string, body?: unknown, token?: string, epoch = this.revision): Promise<unknown> {
    const config = this.requireInitialized();
    this.checkEpoch(epoch);
    const controller = new AbortController();
    this.requests.add(controller);
    let timedOut = false;
    const timeout = setTimeout(() => { timedOut = true; controller.abort(); }, config.requestTimeoutMs);
    try {
      const response = await fetch(`${config.apiBaseUrl}${path}`, {
        method, headers: { Accept: 'application/json', ...(body !== undefined ? { 'Content-Type': 'application/json' } : {}),
          ...(token ? { Authorization: `Bearer ${token}` } : {}) },
        body: body === undefined ? undefined : JSON.stringify(body), signal: controller.signal,
        credentials: 'omit', cache: 'no-store', redirect: 'error', referrerPolicy: 'no-referrer',
      });
      this.checkEpoch(epoch);
      let envelope: Json;
      try { envelope = object(await response.json()); }
      catch { throw new ImSdkError('INVALID_RESPONSE', '服务响应格式无效', response.status); }
      this.checkEpoch(epoch);
      if (!response.ok || envelope.code !== 'OK') {
        const code = /^[A-Z][A-Z0-9_\.]{0,79}$/.test(string(envelope.code)) ? string(envelope.code) : `HTTP_${response.status}`;
        throw new ImSdkError(code, response.status === 401 ? '登录状态已失效，请重新登录' : /CAPTCHA/.test(code) ? '请完成安全验证后重试' : '请求未完成，请重试或联系应用提供方', response.status);
      }
      return envelope.data;
    } catch (error) {
      this.checkEpoch(epoch);
      if (timedOut) throw new ImSdkError('REQUEST_TIMEOUT', '请求超时，请重试');
      if (error instanceof ImSdkError) throw error;
      throw new ImSdkError('NETWORK_ERROR', '网络连接失败，请检查网络和跨域配置');
    } finally { clearTimeout(timeout); this.requests.delete(controller); }
  }

  private requireInitialized(): Readonly<ImSdkConfig> {
    if (this.disposed) throw new ImSdkError('DISPOSED', 'SDK已释放');
    if (!this.settings) throw new ImSdkError('NOT_INITIALIZED', '请先初始化SDK');
    return this.settings;
  }
  private requireSession(): ImSdkCredentials {
    this.requireInitialized();
    if (!this.credentials) throw new ImSdkError('NOT_AUTHENTICATED', '请先登录或提交IM凭证');
    return this.credentials;
  }
  private checkEpoch(epoch: number): void {
    if (epoch !== this.revision || this.disposed) throw new ImSdkError('SESSION_CHANGED', '登录状态已变化，请重新操作');
  }
  private targetPath(target: ConversationTarget): string {
    if (!['direct', 'group'].includes(target.type)) throw new ImSdkError('INVALID_ARGUMENT', '会话类型无效');
    return `${API}/${target.type === 'group' ? 'groups' : 'direct-chats'}/${encodeURIComponent(required(target.conversationId, 'conversationId'))}`;
  }
  private validateSeq(seq: number): void {
    if (!Number.isSafeInteger(seq) || seq < 0) throw new ImSdkError('INVALID_ARGUMENT', '消息序号无效');
  }
  private limit(limit = 50): number {
    if (!Number.isSafeInteger(limit) || limit < 1 || limit > 100) throw new ImSdkError('INVALID_ARGUMENT', '分页大小需要1到100');
    return limit;
  }
  private failure(error: unknown): ImSdkError {
    return error instanceof ImSdkError ? error : new ImSdkError('SDK_ERROR', '操作未完成，请重试');
  }
}
