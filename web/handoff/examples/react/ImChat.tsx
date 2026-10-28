import { useEffect, useRef, useState } from 'react';
import { ImSdkClient, ImSdkError, mountMessenger, type ImSdkConfig } from '@imsdk/web';

export interface ImChatProps {
  /** Keep this object stable (module constant or useMemo); a change starts a new SDK session. */
  config: ImSdkConfig;
}

/** Mount from a browser component. The SDK handles the account/password UI. */
export function ImChat({ config }: ImChatProps) {
  const container = useRef<HTMLDivElement>(null);
  const [error, setError] = useState('');

  useEffect(() => {
    const element = container.current;
    if (!element) return;
    const client = new ImSdkClient();
    let closeView: (() => void) | undefined;
    setError('');
    try {
      client.initialize(config);
      const view = mountMessenger(client, element);
      closeView = () => view.close();
    } catch (failure) {
      setError(failure instanceof ImSdkError ? failure.message : '聊天初始化失败');
    }
    return () => {
      closeView?.();
      // Local cleanup retires credentials/requests before its promise completes.
      void client.shutdown().catch(() => {});
    };
  }, [config]);

  return (
    <section aria-label="聊天模块">
      {error ? <p role="alert">{error}</p> : null}
      <div ref={container} style={{ height: '80vh', minHeight: 420 }} />
    </section>
  );
}
