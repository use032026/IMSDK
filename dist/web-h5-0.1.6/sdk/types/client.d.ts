import { type ImSdkConfig, type ImSdkCredentials, type ImSdkEvent, type LoginRequest, type CaptchaChallenge, type Conversation, type ConversationPage, type ConversationTarget, type Message, type PageOptions, type MessagePageOptions, type CustomerServiceRequest, type CustomerServiceSession, type Contact, type RegistrationRequest, type RegistrationCodeRequest, type RegistrationVerificationSettings, type UserSearchResult, type FriendRequest, type FriendRequestSubmission, type CreateGroupRequest, type HostSessionProvider, type ImSdkPresentation } from './types.js';
/** One account per instance. No global state, persistent credentials or automatic sends. */
export declare class ImSdkClient {
    private settings?;
    private credentials?;
    private disposed;
    private revision;
    private listeners;
    private requests;
    private refreshTask?;
    private gateway?;
    private stopping;
    private hostProvider?;
    private hostUnsubscribe?;
    private hostEpoch;
    private hostSession?;
    private hostSync?;
    private hostSyncForced;
    private hostCalls;
    private conversationCache?;
    get isInitialized(): boolean;
    get isAuthenticated(): boolean;
    get sessionRevision(): number;
    /** A memory-only first page, visible only to its still-active IM identity. */
    get cachedConversations(): ConversationPage | undefined;
    get config(): ImSdkConfig | undefined;
    get currentUser(): {
        userId: string;
        platformUserId: string;
        spaceId: string;
    } | undefined;
    /** Apply host display preferences atomically without touching account or page state. */
    updatePresentation(presentation: ImSdkPresentation): void;
    on(listener: (event: ImSdkEvent) => void): () => void;
    private emit;
    /** Bind once to the host account lifecycle. Binding also starts a silent prewarm. */
    bindHostSessionProvider(provider: HostSessionProvider): void;
    /** Recheck the host at page entry; null silently clears the local SDK session. */
    synchronizeHostSession(options?: {
        forceRefresh?: boolean;
    }): Promise<boolean>;
    /** Call this when the host has no subscription API. Invalidation happens before the first await. */
    notifyHostSessionChanged(): Promise<boolean>;
    private synchronizeHost;
    private readHostSession;
    private sameHost;
    private credentialOwner;
    private checkHostEpoch;
    private hostCall;
    private cancelHostCalls;
    private invalidateHostSession;
    private detachHostProvider;
    private hostFailure;
    private requireHostManaged;
    private requireStandaloneAuth;
    initialize(config: ImSdkConfig): void;
    requestLoginCaptcha(): Promise<CaptchaChallenge>;
    getRegistrationVerificationSettings(): Promise<RegistrationVerificationSettings>;
    sendRegistrationCode(request: RegistrationCodeRequest): Promise<void>;
    /** Defaults to personal space; a resolved server-assigned enterprise session is used as returned. */
    registerWithPassword(request: RegistrationRequest): Promise<void>;
    loginWithPassword(request: LoginRequest): Promise<void>;
    authenticate(credentials: ImSdkCredentials): Promise<void>;
    private validateCredentials;
    listConversations(options?: PageOptions): Promise<ConversationPage>;
    getConversation(id: string): Promise<Conversation>;
    listMessages(target: ConversationTarget, options?: MessagePageOptions): Promise<Message[]>;
    sendText(target: ConversationTarget, text: string, options?: {
        clientMessageId?: string;
    }): Promise<Message>;
    markRead(target: ConversationTarget, seq: number): Promise<void>;
    createDirectConversation(peerUserId: string): Promise<Conversation>;
    listContacts(): Promise<Contact[]>;
    searchUsers(keyword: string): Promise<UserSearchResult[]>;
    sendFriendRequest(toUserId: string, message?: string): Promise<FriendRequestSubmission>;
    listFriendRequests(): Promise<FriendRequest[]>;
    handleFriendRequest(requestId: string, action: 'accept' | 'reject'): Promise<void>;
    createGroup(request: CreateGroupRequest): Promise<Conversation>;
    requestCustomerService(request: CustomerServiceRequest): Promise<CustomerServiceSession>;
    logout(): Promise<void>;
    shutdown(): Promise<void>;
    private retireSession;
    private activate;
    private expireSession;
    private verifyIdentity;
    private parseCredentials;
    private registrationCredentials;
    private refresh;
    private accessToken;
    private authorized;
    private raw;
    private requireInitialized;
    private captchaFields;
    private registrationIdentifier;
    private requireSession;
    private checkEpoch;
    private targetPath;
    private validateSeq;
    private limit;
    private failure;
}
