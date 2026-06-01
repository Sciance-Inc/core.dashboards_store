<script setup lang="ts">
defineProps({
  icon: {
    type: String,
    default: ''
  }
})
</script>

<template>
  <div class="card legacy-prose-card">
    <Icon v-if="icon" class="card__icon" :name="icon" />
    <div class="card__title">
      <slot name="title">
        Card title
      </slot>
    </div>
    <div class="card__description">
      <slot name="description">
        Card description
      </slot>
    </div>
    <slot />
  </div>
</template>

<style scoped>
.card {
  display: block;
  width: 100%;
  padding: 2rem;
  border-radius: 0.75rem;
  color: var(--ui-text);
  backdrop-filter: blur(12px);
}

.card__icon {
  display: inline-block;
  width: 1.5rem;
  height: 1.5rem;
  margin-bottom: 0.5rem;
  color: var(--ui-primary);
}

.card__title {
  margin-bottom: 0.5rem;
  color: var(--ui-text-highlighted);
  font-size: 1.125rem;
  font-weight: 700;
  line-height: 1.75rem;
}

.card__title :deep(p),
.card__description :deep(p) {
  margin: 0;
}

.card__description {
  color: var(--ui-text-muted);
  font-size: 0.875rem;
  font-weight: 500;
  line-height: 1.5rem;
}
</style>
