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
  border-color: color-mix(in srgb, var(--ui-primary) 35%, transparent);
  background: color-mix(in srgb, var(--ui-primary) 12%, transparent);
  color: var(--ui-primary);
}

.alert--success {
  border-color: color-mix(in srgb, var(--ui-success) 35%, transparent);
  background: color-mix(in srgb, var(--ui-success) 12%, transparent);
  color: var(--ui-success);
}

.alert--warning {
  border-color: color-mix(in srgb, var(--ui-warning) 35%, transparent);
  background: color-mix(in srgb, var(--ui-warning) 12%, transparent);
  color: var(--ui-warning);
}

.alert--danger {
  border-color: color-mix(in srgb, var(--ui-error) 35%, transparent);
  background: color-mix(in srgb, var(--ui-error) 12%, transparent);
  color: var(--ui-error);
}
</style>
