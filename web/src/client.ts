import {
  ImSdkError, type ImSdkConfig, type ImSdkCredentials, type ImSdkEvent,
  type LoginRequest, type CaptchaChallenge, type Conversation, type ConversationPage,
  type ConversationTarget, type Message, type PageOptions, type MessagePageOptions,
  type CustomerServiceRequest, type CustomerServiceSession, type Contact,
  type RegistrationRequest, type RegistrationCodeRequest, type RegistrationVerificationSettings,
  type UserSearchResult, type FriendRequest, type FriendRequestSubmission, type CreateGroupRequest,
  type HostSession, type HostSessionProvider,
  type ImSdkPresentation,
} from './types.js';
import { object, required, string, conversation, message, acceptedClaims, createClientMessageId, type Json } from './protocol.js';
import { ImSdkGateway } from './gateway.js';
import { normalizePresentation } from './presentation.js';

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
  private hostProvider?: HostSessionProvider;
  private hostUnsubscribe?: () => void;
  private hostEpoch = 0;
  private hostSession?: HostSession;
  private hostSync?: Promise<boolean>;
  private hostSyncForced = false;
  private hostCalls = new Set<() => void>();
  private conversationCache?: { owner: string; page: ConversationPage };

  get isInitialized(): boolean { return !!this.settings && !this.disposed; }
  get isAuthenticated(): boolean { return this.isInitialized && !!this.credentials; }
  get sessionRevision(): number { return this.revision; }
  /** A memory-only first page, visible only to its still-active IM identity. */
  get cachedConversations(): ConversationPage | undefined {
    if (!this.isAuthenticated || this.conversationCache?.owner !== this.credentialOwner(this.credentials!)) return undefined;
    const page = this.conversationCache.page;
    return { ...page, items: page.items.map(item => ({ ...item })) };
  }
  get config(): ImSdkConfig | undefined {
    return this.settings ? { ...this.settings, passwordLogin: this.settings.passwordLogin && { ...this.settings.passwordLogin } } : undefined;
  }
  get currentUser(): { userId: string; platformUserId: string; spaceId: string } | undefined {
    const c = this.credentials;
    return c ? { userId: c.userId, platformUserId: c.platformUserId, spaceId: c.spaceId } : undefined;
  }

  /** Apply host display preferences atomically without touching account or page state. */
  updatePresentation(presentation: ImSdkPresentation): void {
    const settings = this.requireInitialized();
    const next = normalizePresentation(presentation, settings);
    if (next.themeMode === settings.themeMode && next.locale === settings.locale) return;
    this.settings = Object.freeze({ ...settings, ...next });
    this.emit({ type: 'presentationChanged', ...next });
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

  /** Bind once to the host account lifecycle. Binding also starts a silent prewarm. */
  bindHostSessionProvider(provider: HostSessionProvider): void {
    this.requireHostManaged();
    if (!provider || typeof provider.readSession !== 'function' || typeof provider.fetchCredentials !== 'function' ||
        (provider.subscribe !== undefined && typeof provider.subscribe !== 'function')) {
      throw new ImSdkError('INVALID_HOST_SESSION_PROVIDER', '宿主登录态接口无效');
    }
    this.detachHostProvider();
    this.invalidateHostSession();
    this.hostProvider = provider;
    try {
      this.hostUnsubscribe = provider.subscribe?.(() => {
        if (this.hostProvider === provider && !this.disposed) void this.notifyHostSessionChanged().catch(error => this.hostFailure(error));
      });
    } catch {
      this.hostProvider = undefined;
      throw new ImSdkError('HOST_SESSION_SUBSCRIPTION_FAILED', '暂时无法同步宿主账号，请重试');
    }
    void this.synchronizeHostSession().catch(error => this.hostFailure(error));
  }

  /** Recheck the host at page entry; null silently clears the local SDK session. */
  synchronizeHostSession(options: { forceRefresh?: boolean } = {}): Promise<boolean> {
    this.requireHostManaged();
    if (this.hostSync) {
      if (options.forceRefresh && !this.hostSyncForced) {
        const epoch = this.hostEpoch, provider = this.hostProvider!;
        return this.hostSync.then(authenticated => {
          this.checkHostEpoch(provider, epoch);
          return authenticated ? this.synchronizeHostSession(options) : false;
        });
      }
      return this.hostSync;
    }
    const provider = this.hostProvider;
    if (!provider) return Promise.reject(new ImSdkError('HOST_SESSION_PROVIDER_REQUIRED', '宿主尚未连接账号，请稍后重试'));
    const epoch = this.hostEpoch;
    const task = this.synchronizeHost(provider, epoch, options.forceRefresh === true);
    this.hostSync = task;
    this.hostSyncForced = options.forceRefresh === true;
    void task.finally(() => { if (this.hostSync === task) this.hostSync = undefined; }).catch(() => {});
    return task;
  }

  /** Call this when the host has no subscription API. Invalidation happens before the first await. */
  notifyHostSessionChanged(): Promise<boolean> {
    this.requireHostManaged();
    this.invalidateHostSession();
    return this.synchronizeHostSession();
  }

  private async synchronizeHost(provider: HostSessionProvider, epoch: number, forceRefresh: boolean): Promise<boolean> {
    try {
      const session = await this.readHostSession(provider, epoch);
      if (!session) {
        this.hostSession = undefined;
        this.retireSession();
        this.emit({ type: 'hostSessionSynchronized', authenticated: false });
        return false;
      }
      if (this.hostSession && !this.sameHost(this.hostSession, session)) {
        this.hostSession = undefined;
        this.retireSession();
      }
      if (!forceRefresh && this.sameHost(this.hostSession, session) && this.credentials &&
          Date.parse(this.credentials.expiresAt) - Date.now() >= 30000) return true;
      this.emit({ type: 'hostSessionSynchronizing' });
      const supplied = await this.hostCall(provider, epoch,
        () => provider.fetchCredentials(Object.freeze({ ...session })), 'HOST_CREDENTIALS');
      const credentials = { ...supplied };
      this.checkHostEpoch(provider, epoch);
      this.validateCredentials(credentials);
      if (!this.sameHost(await this.readHostSession(provider, epoch), session)) {
        this.invalidateHostSession();
        throw new ImSdkError('SESSION_CHANGED', '宿主账号已变化，请重新进入');
      }
      const sdkEpoch = this.revision;
      await this.verifyIdentity(credentials, sdkEpoch);
      this.checkHostEpoch(provider, epoch);
      if (!this.sameHost(await this.readHostSession(provider, epoch), session)) {
        this.invalidateHostSession();
        throw new ImSdkError('SESSION_CHANGED', '宿主账号已变化，请重新进入');
      }
      this.checkEpoch(sdkEpoch);
      const current = this.credentials;
      if (current && this.sameHost(this.hostSession, session)) {
        if (this.credentialOwner(current) !== this.credentialOwner(credentials)) {
          this.invalidateHostSession();
          throw new ImSdkError('HOST_IDENTITY_MISMATCH', '宿主账号对应的聊天身份已变化，请重新进入');
        }
        this.credentials = credentials;
        this.refreshTask = undefined;
      } else {
        this.hostSession = { ...session };
        this.activate(credentials, sdkEpoch);
      }
      this.emit({ type: 'hostSessionSynchronized', authenticated: true });
      return true;
    } catch (error) {
      this.checkHostEpoch(provider, epoch);
      this.hostSession = undefined;
      this.retireSession();
      const failure = error instanceof ImSdkError ? error : new ImSdkError('HOST_SESSION_UNAVAILABLE', '暂时无法同步宿主账号，请重试');
      this.hostFailure(failure);
      throw failure;
    }
  }

  private async readHostSession(provider: HostSessionProvider, epoch: number): Promise<HostSession | null> {
    const session = await this.hostCall(provider, epoch, () => provider.readSession(), 'HOST_SESSION');
    this.checkHostEpoch(provider, epoch);
    if (session === null) return null;
    if (!session || typeof session.hostUserId !== 'string' || !session.hostUserId.trim() ||
        typeof session.sessionId !== 'string' || !session.sessionId.trim()) {
      throw new ImSdkError('INVALID_HOST_SESSION', '宿主账号状态无效，请重试');
    }
    return { hostUserId: session.hostUserId, sessionId: session.sessionId };
  }

  private sameHost(left: HostSession | null | undefined, right: HostSession | null | undefined): boolean {
    return !!left && !!right && left.hostUserId === right.hostUserId && left.sessionId === right.sessionId;
  }
  private credentialOwner(credentials: ImSdkCredentials): string {
    return JSON.stringify([credentials.platformUserId, credentials.spaceId, credentials.userId]);
  }
  private checkHostEpoch(provider: HostSessionProvider, epoch: number): void {
    if (this.disposed || this.hostProvider !== provider || this.hostEpoch !== epoch) {
      throw new ImSdkError('SESSION_CHANGED', '宿主账号已变化，请重新进入');
    }
  }
  private async hostCall<T>(provider: HostSessionProvider, epoch: number, action: () => Promise<T>, code: string): Promise<T> {
    this.checkHostEpoch(provider, epoch);
    let timer: ReturnType<typeof setTimeout> | undefined;
    let cancel: (() => void) | undefined;
    try {
      const value = await new Promise<T>((resolve, reject) => {
        cancel = () => reject(new ImSdkError('SESSION_CHANGED', '宿主账号已变化，请重新进入'));
        this.hostCalls.add(cancel);
        timer = setTimeout(() => reject(new ImSdkError(`${code}_TIMEOUT`, '账号同步超时，请重试')), this.settings!.requestTimeoutMs);
        Promise.resolve().then(() => { this.checkHostEpoch(provider, epoch); return action(); }).then(resolve,
          () => reject(new ImSdkError(`${code}_UNAVAILABLE`, '暂时无法同步宿主账号，请重试')));
      });
      this.checkHostEpoch(provider, epoch);
      return value;
    } finally {
      if (timer !== undefined) clearTimeout(timer);
      if (cancel) this.hostCalls.delete(cancel);
    }
  }
  private cancelHostCalls(): void {
    for (const cancel of this.hostCalls) cancel();
    this.hostCalls.clear();
  }
  private invalidateHostSession(): void {
    this.hostEpoch++;
    this.cancelHostCalls();
    this.hostSync = undefined;
    this.hostSession = undefined;
    this.retireSession();
  }
  private detachHostProvider(): void {
    const unsubscribe = this.hostUnsubscribe;
    this.hostUnsubscribe = undefined;
    this.hostProvider = undefined;
    try { unsubscribe?.(); } catch { /* A host callback cannot retain the old account. */ }
  }
  private hostFailure(error: unknown): void {
    if (!this.disposed && (!(error instanceof ImSdkError) || error.code !== 'SESSION_CHANGED')) {
      this.emit({ type: 'hostSessionError', code: error instanceof ImSdkError ? error.code : 'HOST_SESSION_UNAVAILABLE' });
    }
  }
  private requireHostManaged(): void {
    if (!this.requireInitialized().hostManagedAuth) throw new ImSdkError('HOST_MANAGED_AUTH_REQUIRED', '请启用宿主账号同步模式');
  }
  private requireStandaloneAuth(): void {
    if (this.requireInitialized().hostManagedAuth) throw new ImSdkError('HOST_MANAGED_AUTH_REQUIRED', '聊天账号由宿主自动同步');
  }

  initialize(config: ImSdkConfig): void {
    if (this.disposed) throw new ImSdkError('DISPOSED', 'SDK已释放');
    if (this.settings) throw new ImSdkError('CONFIG_CONFLICT', '请为新配置创建新的SDK实例');
    if (config.privacyConsentGranted !== true) throw new ImSdkError('CONSENT_REQUIRED', '宿主需先取得用户同意');
    if (config.hostManagedAuth !== undefined && typeof config.hostManagedAuth !== 'boolean') throw new ImSdkError('INVALID_CONFIG', '宿主账号同步配置无效');
    const presentation = normalizePresentation({ themeMode: config.themeMode, locale: config.locale });
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
      pollIntervalMs: config.pollIntervalMs ?? 15000, hostManagedAuth: config.hostManagedAuth ?? false, ...presentation });
    this.emit({ type: 'ready' });
  }

  async requestLoginCaptcha(): Promise<CaptchaChallenge> {
    this.requireInitialized();
    const data = object(await this.raw(`${API}/auth/captcha/generate`, 'POST'));
    return { token: required(data.token, 'captcha token'), question: required(data.question ?? data.captchaQuestion, 'captcha question') };
  }

  async getRegistrationVerificationSettings(): Promise<RegistrationVerificationSettings> {
    const data = object(await this.raw(`${PLATFORM}/auth/verification/settings`, 'GET'));
    return { smsEnabled: data.smsEnabled === true, emailEnabled: data.emailEnabled === true,
      smsRequired: data.smsRequired === true, emailRequired: data.emailRequired === true };
  }

  async sendRegistrationCode(request: RegistrationCodeRequest): Promise<void> {
    const identifier = this.registrationIdentifier(request);
    const epoch = this.revision;
    const settings = await this.getRegistrationVerificationSettings();
    this.checkEpoch(epoch);
    if (!(request.channel === 'sms' ? settings.smsEnabled : settings.emailEnabled)) {
      throw new ImSdkError('REGISTER_CHANNEL_DISABLED', '当前注册方式暂不可用');
    }
    const data = object(await this.raw(`${PLATFORM}/auth/verification/send`, 'POST', {
      identifier, channel: request.channel, purpose: 'register', ...this.captchaFields(request),
    }, undefined, epoch));
    if (data.sent !== true) throw new ImSdkError('VERIFICATION_SEND_FAILED', '验证码发送失败，请稍后重试');
  }

  /** Defaults to personal space; a resolved server-assigned enterprise session is used as returned. */
  async registerWithPassword(request: RegistrationRequest): Promise<void> {
    this.requireStandaloneAuth();
    const identifier = this.registrationIdentifier(request);
    const displayName = required(request.displayName, '昵称');
    if (typeof request.password !== 'string' || request.password.length < 6) throw new ImSdkError('INVALID_ARGUMENT', '密码至少6位');
    const verificationCode = string(request.verificationCode);
    const captcha = this.captchaFields(request);
    const epoch = this.retireSession();
    let accountCreated = false;
    try {
      const settings = await this.getRegistrationVerificationSettings();
      this.checkEpoch(epoch);
      if (!(request.channel === 'sms' ? settings.smsEnabled : settings.emailEnabled)) {
        throw new ImSdkError('REGISTER_CHANNEL_DISABLED', '当前注册方式暂不可用');
      }
      if ((request.channel === 'sms' ? settings.smsRequired : settings.emailRequired) && !verificationCode) {
        throw new ImSdkError('AUTH_VERIFICATION_REQUIRED', '请输入注册验证码');
      }
      const registration = object(await this.raw(`${PLATFORM}/auth/register`, 'POST', {
        displayName, password: request.password, loginType: request.channel === 'sms' ? 'mobile' : 'email',
        [request.channel === 'sms' ? 'mobile' : 'email']: identifier, ...(verificationCode ? { verificationCode } : {}), ...captcha,
      }, undefined, epoch));
      accountCreated = true;
      if (registration.pendingApproval === true) throw new ImSdkError('REGISTER_PENDING_APPROVAL', '账号已注册，尚需服务端审核后才能登录');
      let data = registration;
      const platformToken = string(registration.platformToken);
      if (!string(registration.accessToken)) {
        data = object(await this.raw(`${PLATFORM}/auth/select-personal-space`, 'POST', undefined,
          required(platformToken, 'platformToken'), epoch));
      }
      const credentials = this.registrationCredentials(data);
      credentials.platformToken = platformToken || undefined;
      credentials.platformRefreshToken = string(registration.platformRefreshToken) || undefined;
      credentials.deviceSessionToken = registration.deviceSession ? string(object(registration.deviceSession).deviceSessionToken) || undefined : undefined;
      if (!credentials.platformUserId) credentials.platformUserId = string(registration.platformUserId);
      await this.verifyIdentity(credentials, epoch);
      this.activate(credentials, epoch);
    } catch (error) {
      const cause = this.failure(error);
      const failure = accountCreated && !['REGISTER_PENDING_APPROVAL', 'SESSION_CHANGED', 'DISPOSED'].includes(cause.code)
        ? new ImSdkError('REGISTER_LOGIN_FAILED', '账号已注册，暂未能完成登录，请返回登录重试') : cause;
      if (epoch === this.revision) this.emit({ type: 'authenticationFailed', code: failure.code });
      throw failure;
    }
  }

  async loginWithPassword(request: LoginRequest): Promise<void> {
    this.requireStandaloneAuth();
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
          identifier: account, password: request.password,
          loginType: login.space === 'personal'
            ? (/^1[3-9]\d{9}$/.test(account) ? 'mobile' : /^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$/.test(account) ? 'email' : login.loginType)
            : login.loginType, ...captcha,
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
    this.requireStandaloneAuth();
    const copy = { ...credentials };
    this.validateCredentials(copy);
    const epoch = this.retireSession();
    await this.verifyIdentity(copy, epoch);
    this.activate(copy, epoch);
  }

  private validateCredentials(copy: ImSdkCredentials): void {
    for (const field of ['userId', 'platformUserId', 'spaceId', 'accessToken', 'refreshToken'] as const) required(copy[field], field);
    if (!Number.isFinite(Date.parse(copy.expiresAt)) || Date.parse(copy.expiresAt) <= Date.now()) {
      throw new ImSdkError('CREDENTIALS_EXPIRED', '请向宿主后端获取有效IM凭证');
    }
  }

  async listConversations(options: PageOptions = {}): Promise<ConversationPage> {
    const revision = this.revision;
    const hostEpoch = this.hostEpoch;
    const query = new URLSearchParams({ limit: String(this.limit(options.limit)) });
    if (options.cursor) query.set('cursor', options.cursor);
    const data = object(await this.authorized(`${API}/conversations?${query}`));
    if (revision !== this.revision || hostEpoch !== this.hostEpoch) throw new ImSdkError('SESSION_CHANGED', '登录状态已变化，请重新操作');
    if (!Array.isArray(data.items)) throw new ImSdkError('INVALID_RESPONSE', '会话列表格式无效');
    // Temporary service sessions are outside this public direct/group API.
    const page = { items: data.items.filter(x => ['direct', 'group'].includes(string(object(x).conversationType))).map(conversation),
      nextCursor: string(data.nextCursor) || undefined };
    if (!options.cursor && this.credentials) this.conversationCache = { owner: this.credentialOwner(this.credentials), page };
    return page;
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
    return { conversationId: id, type: 'direct', title: string(data.title) || '聊天', ...(!string(data.title) ? { titleIsDefault: true } : {}), peerUserId: peer, unreadCount: 0 };
  }

  async listContacts(): Promise<Contact[]> {
    const data = await this.authorized(`${API}/friends`);
    if (!Array.isArray(data)) throw new ImSdkError('INVALID_RESPONSE', '联系人列表格式无效');
    return data.map(value => {
      const row = object(value);
      return { userId: required(row.friendUserId ?? row.userId, 'userId'),
        displayName: string(row.remarkName) || string(row.displayName) || string(row.name) || '联系人',
        ...(!(string(row.remarkName) || string(row.displayName) || string(row.name)) ? { displayNameIsDefault: 'contact' as const } : {}) };
    });
  }

  async searchUsers(keyword: string): Promise<UserSearchResult[]> {
    const query = new URLSearchParams({ keyword: required(keyword, '搜索内容') });
    const data = await this.authorized(`${API}/search/users?${query}`);
    if (!Array.isArray(data)) throw new ImSdkError('INVALID_RESPONSE', '用户搜索结果格式无效');
    return data.map(value => {
      const row = object(value);
      return { userId: required(row.userId, 'userId'), displayName: string(row.displayName) || string(row.name) || '用户',
        ...(!(string(row.displayName) || string(row.name)) ? { displayNameIsDefault: 'user' as const } : {}),
        ...(typeof row.isFriend === 'boolean' ? { isFriend: row.isFriend } : {}), ...(string(row.lppId) ? { lppId: string(row.lppId) } : {}) };
    });
  }

  async sendFriendRequest(toUserId: string, message?: string): Promise<FriendRequestSubmission> {
    const peer = required(toUserId, 'toUserId');
    if (peer === this.requireSession().userId) throw new ImSdkError('INVALID_ARGUMENT', '不能添加自己为好友');
    if (message !== undefined && typeof message !== 'string') throw new ImSdkError('INVALID_ARGUMENT', '申请消息无效');
    const data = object(await this.authorized(`${API}/friends/request`, 'POST', { toUserId: peer, ...(message !== undefined ? { message } : {}) }));
    const requestId = required(data.requestId, 'requestId');
    const status = string(data.status).toLowerCase();
    if (status !== 'pending' && status !== 'accepted') throw new ImSdkError('INVALID_RESPONSE', '好友申请状态无效');
    this.emit({ type: 'contactsChanged' });
    return { requestId, status };
  }

  async listFriendRequests(): Promise<FriendRequest[]> {
    const data = await this.authorized(`${API}/friends/requests`);
    if (!Array.isArray(data)) throw new ImSdkError('INVALID_RESPONSE', '好友申请列表格式无效');
    return data.map(value => {
      const row = object(value);
      const rawStatus = string(row.status).toLowerCase();
      const status = ['pending', 'accepted', 'rejected', 'cancelled'].includes(rawStatus) ? rawStatus as FriendRequest['status'] : 'unknown';
      return { requestId: required(row.requestId, 'requestId'), fromUserId: required(row.fromUserId, 'fromUserId'),
        fromDisplayName: string(row.fromDisplayName) || '用户', toUserId: required(row.toUserId, 'toUserId'),
        toDisplayName: string(row.toDisplayName) || '用户', message: string(row.message) || undefined, status,
        ...(!string(row.fromDisplayName) ? { fromNameIsDefault: true } : {}), ...(!string(row.toDisplayName) ? { toNameIsDefault: true } : {}) };
    });
  }

  async handleFriendRequest(requestId: string, action: 'accept' | 'reject'): Promise<void> {
    if (action !== 'accept' && action !== 'reject') throw new ImSdkError('INVALID_ARGUMENT', '好友申请操作无效');
    try {
      await this.authorized(`${API}/friends/requests/${encodeURIComponent(required(requestId, 'requestId'))}/handle`, 'POST', { action });
    } catch (error) {
      if (!(error instanceof ImSdkError) || error.status !== 409 || error.code !== 'FRIEND_REQUEST_HANDLED') throw error;
    }
    this.emit({ type: 'contactsChanged' });
  }

  async createGroup(request: CreateGroupRequest): Promise<Conversation> {
    const title = required(request.title, '群名称');
    if (request.memberUserIds !== undefined && !Array.isArray(request.memberUserIds)) throw new ImSdkError('INVALID_ARGUMENT', '群成员列表无效');
    const members = [...new Set((request.memberUserIds ?? []).map(id => required(id, 'memberUserId')))];
    const userId = this.requireSession().userId;
    const memberUserIds = members.filter(id => id !== userId);
    const data = object(await this.authorized(`${API}/groups/`, 'POST', { title, ...(memberUserIds.length ? { memberUserIds } : {}) }));
    const conversationId = required(data.groupId, 'groupId');
    this.emit({ type: 'conversationsChanged' });
    return { conversationId, type: 'group', title, unreadCount: 0 };
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
    if (this.settings!.hostManagedAuth) this.invalidateHostSession();
    else this.retireSession();
    this.emit({ type: 'loggedOut' });
    await Promise.all([...this.stopping]);
  }

  async shutdown(): Promise<void> {
    if (this.disposed) { await Promise.all([...this.stopping]); return; }
    this.hostEpoch++;
    this.cancelHostCalls();
    this.hostSync = undefined;
    this.hostSession = undefined;
    this.detachHostProvider();
    this.retireSession();
    this.disposed = true;
    this.emit({ type: 'shutdown' });
    this.listeners.clear();
    await Promise.all([...this.stopping]);
  }

  private retireSession(): number {
    const epoch = ++this.revision;
    this.credentials = undefined;
    this.conversationCache = undefined;
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
    if (this.settings?.hostManagedAuth) {
      this.invalidateHostSession();
      this.emit({ type: 'hostSessionError', code: 'SESSION_EXPIRED' });
      return;
    }
    this.retireSession();
    this.emit({ type: 'authenticationRequired', code: 'SESSION_EXPIRED' });
  }
  private async verifyIdentity(credentials: ImSdkCredentials, epoch: number): Promise<void> {
    const profile = object(await this.raw(`${API}/profile/me`, 'GET', undefined, credentials.accessToken, epoch));
    const claims = acceptedClaims(credentials.accessToken);
    const claimUser = string(claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']);
    const claimsBound = !!claimUser && claimUser === string(profile.userId);
    const platformId = string(profile.platformUserId) || (claimsBound ? string(claims.platform_user_id) : '');
    if (!platformId || string(profile.userId) !== credentials.userId || (credentials.platformUserId && platformId !== credentials.platformUserId)) {
      throw new ImSdkError('AUTH_EXTERNAL_IDENTITY_MISMATCH', 'IM凭证与服务端身份不匹配');
    }
    const context = profile.spaceContext ? object(profile.spaceContext) : {};
    if (credentials.spaceId === 'personal' && context.spaceType !== undefined && Number(context.spaceType) !== 1) {
      throw new ImSdkError('AUTH_EXTERNAL_IDENTITY_MISMATCH', '服务端身份不属于个人空间');
    }
    const profileSpace = Number(context.spaceType) === 1 ? 'personal' : string(profile.tenantId) || string(context.tenantId) || string(profile.spaceId);
    const hasClaimSpace = claims.space_type !== undefined || !!string(claims.tenant_id);
    if (!profileSpace && hasClaimSpace && !claimsBound) {
      throw new ImSdkError('AUTH_EXTERNAL_IDENTITY_MISMATCH', '凭证空间无法与服务端身份关联');
    }
    // Personal JWTs retain an internal tenant placeholder. Only the accepted,
    // identity-bound space_type claim determines whether that ticket is personal.
    const claimSpace = claimsBound ? (String(claims.space_type) === '1' ? 'personal' : string(claims.tenant_id)) : '';
    const serverSpace = profileSpace || claimSpace;
    if (serverSpace && serverSpace !== credentials.spaceId) throw new ImSdkError('AUTH_EXTERNAL_IDENTITY_MISMATCH', 'IM凭证与空间不匹配');
    credentials.platformUserId = platformId;
  }

  private parseCredentials(data: Json, previous?: ImSdkCredentials, expectedSpace?: string): ImSdkCredentials {
    const context = data.spaceContext ? object(data.spaceContext) : {};
    if (expectedSpace === 'personal' && context.spaceType !== undefined && Number(context.spaceType) !== 1) {
      throw new ImSdkError('AUTH_CONTEXT_REQUIRED', '服务端返回的空间不是个人空间');
    }
    const spaceId = Number(context.spaceType) === 1 ? 'personal' : string(data.tenantId) || string(context.tenantId) || string(data.spaceId) || expectedSpace || previous?.spaceId || '';
    if (expectedSpace && spaceId !== expectedSpace) throw new ImSdkError('AUTH_CONTEXT_REQUIRED', '登录空间与应用配置不匹配');
    const expiresIn = Number(data.expiresIn ?? 3600);
    if (!Number.isFinite(expiresIn) || expiresIn <= 0) throw new ImSdkError('INVALID_RESPONSE', '凭证有效期无效');
    return { ...previous, userId: string(data.userId) || previous?.userId || '',
      platformUserId: string(data.platformUserId) || previous?.platformUserId || '',
      spaceId: required(spaceId, 'spaceId'), accessToken: required(data.accessToken, 'accessToken'),
      refreshToken: required(data.refreshToken ?? previous?.refreshToken, 'refreshToken'),
      expiresAt: new Date(Date.now() + expiresIn * 1000).toISOString() };
  }

  private registrationCredentials(data: Json): ImSdkCredentials {
    const context = data.spaceContext ? object(data.spaceContext) : {};
    const type = context.spaceType === undefined ? undefined : Number(context.spaceType);
    if (type !== undefined && type !== 1 && type !== 2) throw new ImSdkError('AUTH_CONTEXT_REQUIRED', '注册登录返回的空间尚未确定');
    const returnedId = string(data.tenantId) || string(context.tenantId) || string(data.spaceId);
    const legacyPersonal = returnedId === '11111111-1111-1111-1111-111111111111';
    if (type === 2 && (!returnedId || returnedId === 'personal')) {
      throw new ImSdkError('AUTH_CONTEXT_REQUIRED', '企业登录缺少有效空间标识');
    }
    if (type === 1 || (type === undefined && (returnedId === 'personal' || legacyPersonal))) {
      return this.parseCredentials({ ...data, spaceContext: { ...context, spaceType: 1 } });
    }
    return this.parseCredentials(data);
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
          // A host-issued replacement may have committed while the IM refresh
          // or its identity check was in flight. Never overwrite that newer pair.
          if (this.credentials === previous) this.credentials = next;
        } catch (error) {
          // A rejection from the retired pair must not expire or trigger a new
          // host exchange after a newer verified pair has already committed.
          if (this.revision === epoch && this.credentials && this.credentials !== previous) return;
          const failure = this.failure(error);
          if (!this.settings?.hostManagedAuth && this.revision === epoch && (failure.status === 401 || failure.status === 403 ||
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
    const hostManaged = this.requireInitialized().hostManagedAuth === true;
    if (hostManaged && !await this.synchronizeHostSession()) {
      throw new ImSdkError('HOST_NOT_AUTHENTICATED', '宿主账号已退出');
    }
    this.requireSession();
    const epoch = this.revision;
    const hostEpoch = this.hostEpoch;
    const hostSession = this.hostSession;
    let refreshing = false;
    try {
      refreshing = Date.parse(this.requireSession().expiresAt) - Date.now() < 30000;
      const token = await this.accessToken(epoch);
      refreshing = false;
      try { return await this.raw(path, method, body, token, epoch); }
      catch (error) {
        if (!(error instanceof ImSdkError) || error.status !== 401) throw error;
        this.checkEpoch(epoch);
        if (this.requireSession().accessToken === token) {
          refreshing = true;
          await this.refresh(epoch);
          refreshing = false;
        }
        this.checkEpoch(epoch);
        return await this.raw(path, method, body, this.requireSession().accessToken, epoch);
      }
    }
    catch (error) {
      const authFailure = error instanceof ImSdkError && (error.status === 401 ||
        (refreshing && error.status === 403) || /^(AUTH_|TOKEN_|REFRESH_TOKEN_)/.test(error.code));
      if (hostManaged && authFailure && this.hostEpoch === hostEpoch && this.revision === epoch) {
        await this.synchronizeHostSession({ forceRefresh: true });
        if (this.hostEpoch !== hostEpoch || !this.sameHost(this.hostSession, hostSession)) {
          throw new ImSdkError('SESSION_CHANGED', '宿主账号已变化，请重新操作');
        }
        const recoveredEpoch = this.revision;
        try { return await this.raw(path, method, body, this.requireSession().accessToken, recoveredEpoch); }
        catch (retryError) {
          if (retryError instanceof ImSdkError && retryError.status === 401 && this.revision === recoveredEpoch) this.expireSession();
          throw retryError;
        }
      }
      if (error instanceof ImSdkError && error.status === 401 && this.revision === epoch) this.expireSession();
      throw error;
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
  private captchaFields(request: { captchaToken?: string; captchaAnswer?: string }): Json {
    if ((request.captchaToken !== undefined || request.captchaAnswer !== undefined) &&
        (!string(request.captchaToken) || !string(request.captchaAnswer))) throw new ImSdkError('INVALID_ARGUMENT', '请完成安全验证');
    return request.captchaToken ? { captchaToken: request.captchaToken, captchaAnswer: request.captchaAnswer } : {};
  }
  private registrationIdentifier(request: RegistrationCodeRequest): string {
    if (request.channel !== 'sms' && request.channel !== 'email') throw new ImSdkError('INVALID_ARGUMENT', '注册方式无效');
    const identifier = required(request.identifier, request.channel === 'sms' ? '手机号' : '邮箱');
    const valid = request.channel === 'sms' ? /^1[3-9]\d{9}$/.test(identifier) : /^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$/.test(identifier);
    if (!valid) throw new ImSdkError('INVALID_ARGUMENT', request.channel === 'sms' ? '手机号格式不正确' : '邮箱格式不正确');
    this.captchaFields(request);
    return identifier;
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
