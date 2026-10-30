import type { ImSdkClient } from './client.js';
import type { ConversationTarget, CustomerServiceRequest, CustomerServiceSession } from './types.js';
export interface ImSdkMessenger {
    openConversation(target: ConversationTarget): Promise<void>;
    openCustomerService(request: CustomerServiceRequest): Promise<CustomerServiceSession>;
    close(): void;
}
/** Mounts an isolated chat view. Closing removes only nodes owned by this mount. */
export declare function mountMessenger(client: ImSdkClient, container: HTMLElement): ImSdkMessenger;
