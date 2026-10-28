<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { ImSdkClient, ImSdkError, mountMessenger, type ImSdkConfig } from '@imsdk/web';

// Keep the configuration object stable; replacing it starts a fresh SDK session.
const props = defineProps<{ config: ImSdkConfig }>();
const container = ref<HTMLDivElement | null>(null);
const error = ref('');
let client: ImSdkClient | undefined;
let closeView: (() => void) | undefined;

function release(): void {
  closeView?.();
  closeView = undefined;
  const previous = client;
  client = undefined;
  if (previous) void previous.shutdown().catch(() => {});
}

function mount(): void {
  if (!container.value) return;
  release();
  error.value = '';
  client = new ImSdkClient();
  try {
    client.initialize(props.config);
    const view = mountMessenger(client, container.value);
    closeView = () => view.close();
  } catch (failure) {
    error.value = failure instanceof ImSdkError ? failure.message : '聊天初始化失败';
  }
}

onMounted(mount);
watch(() => props.config, mount, { flush: 'post' });
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
