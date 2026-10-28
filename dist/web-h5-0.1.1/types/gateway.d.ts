import type { ImSdkEvent } from './types.js';
/** Gateway events invalidate REST snapshots; they never become stored messages. */
export declare class ImSdkGateway {
    private readonly emit;
    private readonly onSecurityEvent;
    private readonly connection;
    private stopped;
    private securityHandled;
    private starting?;
    private stopping?;
    private retryTimer?;
    private heartbeatTimer?;
    private retryCount;
    constructor(baseUrl: string, getToken: () => Promise<string>, emit: (event: ImSdkEvent) => void, onSecurityEvent: () => void);
    /** Initial negotiate failures are retried as well as established connections. */
    start(): Promise<void>;
    /** Permanently retires this instance; repeated calls share the stop operation. */
    stop(): Promise<void>;
    private connect;
    private connected;
    private scheduleRetry;
    private clearHeartbeat;
    private send;
}
