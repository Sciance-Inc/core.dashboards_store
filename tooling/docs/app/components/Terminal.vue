<script setup lang="ts">
import type { PropType } from 'vue'

const props = defineProps({
  content: {
    type: [Array, String] as PropType<string[] | string>,
    default: ''
  }
})

const lines = computed(() => {
  if (Array.isArray(props.content)) {
    return props.content
  }

  if (props.content) {
    return [props.content]
  }

  return []
})
</script>

<template>
  <div class="terminal">
    <div class="terminal__header">
      <div class="terminal__controls" aria-hidden="true">
        <span />
        <span />
        <span />
      </div>
      <div class="terminal__title">
        Bash
      </div>
    </div>
    <pre class="terminal__window"><code><span v-for="line in lines" :key="line" class="terminal__line"><span class="terminal__sign">$</span><span>{{ line }}</span></span></code></pre>
  </div>
</template>

<style scoped>
.terminal {
  display: flex;
  flex-direction: column;
  width: 100%;
  min-width: 0;
  max-width: min(32rem, 100%);
  height: 16rem;
  margin: 0 auto;
  overflow: hidden;
  border: 1px solid rgb(212 212 216);
  border-radius: 0.5rem;
  background: white;
}

.terminal__header {
  position: relative;
  display: flex;
  align-items: center;
  height: 3rem;
  border-bottom: 1px solid rgb(212 212 216);
}

.terminal__controls {
  display: flex;
  gap: 0.5rem;
  margin-left: 1rem;
}

.terminal__controls span {
  display: block;
  width: 0.75rem;
  height: 0.75rem;
  border-radius: 999px;
}

.terminal__controls span:nth-child(1) {
  background: rgb(248 113 113);
}

.terminal__controls span:nth-child(2) {
  background: rgb(250 204 21);
}

.terminal__controls span:nth-child(3) {
  background: rgb(74 222 128);
}

.terminal__title {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgb(39 39 42);
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;
  font-weight: 700;
}

.terminal__window {
  flex: 1;
  min-width: 0;
  margin: 0;
  padding: 1rem;
  overflow: auto;
  color: rgb(39 39 42);
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;
  font-size: 0.875rem;
  line-height: 1.5rem;
}

.terminal__window code {
  display: flex;
  flex-direction: column;
  min-width: max-content;
}

.terminal__line {
  display: flex;
}

.terminal__sign {
  flex: 0 0 auto;
  margin-right: 0.5rem;
  font-weight: 700;
  user-select: none;
}
</style>
