import { useEffect, useRef, useState } from 'react';
import { ImSdkClient, mountMessenger, type ImSdkConfig } from '@imsdk/web';

export interface ImChatProps {
  /** Keep this object stable; replacing it recreates a component-owned client. */
  config?: ImSdkConfig;
  /** Reuse a host-owned client, including its authenticated session. */
  client?: ImSdkClient;
}

/** Mount from a browser component. The SDK handles the account/password UI. */
export function ImChat({ config, client: externalClient }: ImChatProps) {
  const container = useRef<HTMLDivElement>(null);
  const [error, setError] = useState('');

  useEffect(() => {
    const element = container.current;
    if (!element) return;
    const client = externalClient ?? new ImSdkClient();
    const ownsClient = !externalClient;
    let closeView: (() => void) | undefined;
    let unsubscribeReady: (() => void) | undefined;
    setError('');
    try {
      unsubscribeReady = client.on(event => {
        if (event.type === 'ready') setError('');
      });
    } catch {
      setError('聊天暂未就绪，请稍后重试或联系应用方。');
    }
    if (config && !client.isInitialized) {
      try {
        client.initialize(config);
      } catch {
        setError('聊天暂未就绪，请稍后重试或联系应用方。');
      }
    }
    try {
      // The login/register shell also supports configuration supplied later by the host.
      const view = mountMessenger(client, element);
      closeView = () => view.close();
    } catch {
      setError('聊天暂未就绪，请稍后重试或联系应用方。');
    }
    return () => {
      unsubscribeReady?.();
      closeView?.();
      // A host-owned client and its authenticated session outlive this view.
      if (ownsClient) void client.shutdown().catch(() => {});
    };
  }, [config, externalClient]);

  return (
    <section aria-label="聊天模块">
      {error ? <p role="alert">{error}</p> : null}
      <div ref={container} style={{ height: '80vh', minHeight: 420 }} />
    </section>
  );
}
