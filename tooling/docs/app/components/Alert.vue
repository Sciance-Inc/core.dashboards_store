<script setup lang="ts">
const props = defineProps({
  type: {
    type: String,
    default: 'info'
  }
})

const normalizedType = computed(() => props.type.trim() || 'info')
</script>

<template>
  <div class="alert" :class="`alert--${normalizedType}`">
    <slot />
  </div>
</template>

<style scoped>
.alert {
  margin: 2rem 0;
  padding: 0.75rem 1rem;
  border: 1px solid;
  border-radius: 0.375rem;
  font-size: 0.875rem;
  line-height: 1.5rem;
}

.alert :deep(p:first-child) {
  margin-top: 0;
}

.alert :deep(p:last-child) {
  margin-bottom: 0;
}

.alert--primary,
.alert--info {
  border-color: rgb(147 197 253);
  background: rgb(239 246 255);
  color: rgb(30 64 175);
}

.alert--success {
  border-color: rgb(134 239 172);
  background: rgb(240 253 244);
  color: rgb(22 101 52);
}

.alert--warning {
  border-color: rgb(253 224 71);
  background: rgb(254 252 232);
  color: rgb(133 77 14);
}

.alert--danger {
  border-color: rgb(252 165 165);
  background: rgb(254 242 242);
  color: rgb(153 27 27);
}
</style>
