<script setup lang="ts">
defineProps({
  type: {
    type: String,
    default: 'primary'
  }
})
</script>

<template>
  <div class="legacy-list" :class="`legacy-list--${type}`">
    <slot />
  </div>
</template>

<style scoped>
.legacy-list {
  --list-color: var(--ui-primary);
  color: var(--ui-text);
}

.legacy-list--success {
  --list-color: var(--ui-success);
}

.legacy-list--info {
  --list-color: var(--ui-info);
}

.legacy-list--warning {
  --list-color: var(--ui-warning);
}

.legacy-list--danger {
  --list-color: var(--ui-error);
}

.legacy-list :deep(ul) {
  margin: 0;
  padding: 0;
  list-style: none;
}

.legacy-list :deep(li) {
  position: relative;
  margin: 0 0 0.75rem;
  padding-left: 2.25rem;
  overflow-wrap: break-word;
}

.legacy-list :deep(li:last-child) {
  margin-bottom: 0;
}

.legacy-list :deep(li::before) {
  content: "";
  position: absolute;
  top: 0.45rem;
  left: 0.35rem;
  width: 0.625rem;
  height: 0.625rem;
  border-radius: 999px;
  background: var(--list-color);
  box-shadow: 0 0 0 0.25rem color-mix(in srgb, var(--list-color), transparent 82%);
}
</style>
