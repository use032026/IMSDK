<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { ImSdkClient, mountMessenger, type ImSdkConfig } from '@imsdk/web';

// Keep config stable; replacing it recreates a component-owned client.
const props = defineProps<{ config?: ImSdkConfig; client?: ImSdkClient }>();
const container = ref<HTMLDivElement | null>(null);
const error = ref('');
let releaseCurrent: (() => void) | undefined;

function release(): void {
  const previous = releaseCurrent;
  releaseCurrent = undefined;
  previous?.();
}

function mount(): void {
  if (!container.value) return;
  release();
  error.value = '';
  const client = props.client ?? new ImSdkClient();
  const ownsClient = !props.client;
  let closeView: (() => void) | undefined;
  let unsubscribeReady: (() => void) | undefined;
  releaseCurrent = () => {
    unsubscribeReady?.();
    closeView?.();
    // A host-owned client and its authenticated session outlive this view.
    if (ownsClient) void client.shutdown().catch(() => {});
  };
  try {
    unsubscribeReady = client.on(event => {
      if (event.type === 'ready') error.value = '';
    });
  } catch {
    error.value = '聊天暂未就绪，请稍后重试或联系应用方。';
  }
  if (props.config && !client.isInitialized) {
    try {
      client.initialize(props.config);
    } catch {
      error.value = '聊天暂未就绪，请稍后重试或联系应用方。';
    }
  }
  try {
    // The login/register shell also supports configuration supplied later by the host.
    const view = mountMessenger(client, container.value);
    closeView = () => view.close();
  } catch {
    error.value = '聊天暂未就绪，请稍后重试或联系应用方。';
  }
}

onMounted(mount);
watch([() => props.config, () => props.client], mount, { flush: 'post' });
onBeforeUnmount(release);
</script>

<template>
  <section aria-label="聊天模块">
    <p v-if="error" role="alert">{{ error }}</p>
    <div ref="container" class="im-chat" />
  </section>
</template>

<style scoped>
.im-chat { height: 80vh; min-height: 420px; }
</style>
