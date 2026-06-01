<script setup lang="ts">
defineProps({
  of: {
    type: String,
    default: ''
  }
})
</script>

<template>
  <div class="props-reference">
    <slot>
      <p v-if="of">
        Props reference for <code>{{ of }}</code>.
      </p>
    </slot>
  </div>
</template>

<style scoped>
.props-reference {
  margin: 1rem 0;
  padding: 1rem;
  border: 1px solid var(--ui-border);
  border-radius: 0.375rem;
  background: var(--ui-bg-muted);
  color: var(--ui-text);
}

.props-reference :deep(p:first-child) {
  margin-top: 0;
}

.props-reference :deep(p:last-child) {
  margin-bottom: 0;
}
</style>
