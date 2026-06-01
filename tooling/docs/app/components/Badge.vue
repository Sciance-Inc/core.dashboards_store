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
  <span class="badge" :class="`badge--${normalizedType}`">
    <slot />
  </span>
</template>

<style scoped>
.badge {
  display: inline-flex;
  align-items: center;
  padding: 0.125rem 0.625rem;
  border: 1px solid;
  border-radius: 999px;
  font-size: 0.875rem;
  font-weight: 600;
  line-height: 1.25rem;
  vertical-align: baseline;
}

.badge--primary,
.badge--info {
  border-color: color-mix(in srgb, var(--ui-primary) 35%, transparent);
  background: color-mix(in srgb, var(--ui-primary) 12%, transparent);
  color: var(--ui-primary);
}

.badge--success {
  border-color: color-mix(in srgb, var(--ui-success) 35%, transparent);
  background: color-mix(in srgb, var(--ui-success) 12%, transparent);
  color: var(--ui-success);
}

.badge--warning {
  border-color: color-mix(in srgb, var(--ui-warning) 35%, transparent);
  background: color-mix(in srgb, var(--ui-warning) 12%, transparent);
  color: var(--ui-warning);
}

.badge--danger {
  border-color: color-mix(in srgb, var(--ui-error) 35%, transparent);
  background: color-mix(in srgb, var(--ui-error) 12%, transparent);
  color: var(--ui-error);
}
</style>
