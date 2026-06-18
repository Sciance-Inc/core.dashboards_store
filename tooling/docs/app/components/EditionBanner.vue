<script setup lang="ts">
import type { PropType } from 'vue'

defineProps({
  icon: {
    type: String,
    default: 'lucide:snowflake'
  },
  cta: {
    type: Array as PropType<string[]>,
    default: () => []
  }
})
</script>

<template>
  <section class="edition-banner">
    <div class="edition-banner__inner">
      <Icon v-if="icon" class="edition-banner__icon" :name="icon" />

      <div v-if="$slots.title" class="edition-banner__title">
        <slot name="title" />
      </div>

      <div v-if="$slots.description" class="edition-banner__description">
        <slot name="description" />
      </div>

      <div class="edition-banner__actions">
        <slot name="actions">
          <NuxtLink
            v-if="cta.length >= 2"
            class="edition-banner__cta"
            :to="cta[1]"
            target="_blank"
            rel="noopener"
          >
            {{ cta[0] }}
          </NuxtLink>
        </slot>
      </div>
    </div>
  </section>
</template>

<style scoped>
.edition-banner {
  box-sizing: border-box;
  width: calc(100% - 2rem);
  max-width: 72rem;
  margin-inline: auto;
  padding: 0 0 5rem;
}

.edition-banner__inner {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 3rem 1.5rem;
  border: 1px solid color-mix(in srgb, var(--ui-primary) 35%, transparent);
  border-radius: 0.75rem;
  background: color-mix(in srgb, var(--ui-primary) 8%, transparent);
  text-align: center;
}

.edition-banner__icon {
  display: inline-block;
  width: 2.25rem;
  height: 2.25rem;
  margin-bottom: 1rem;
  color: var(--ui-primary);
}

.edition-banner__title {
  margin-bottom: 0.75rem;
  color: var(--ui-text-highlighted);
  font-size: 1.5rem;
  font-weight: 800;
  line-height: 2rem;
}

.edition-banner__title :deep(p) {
  margin: 0;
}

.edition-banner__description {
  max-width: 40rem;
  margin-bottom: 2rem;
  color: var(--ui-text-muted);
  font-size: 1.0625rem;
  line-height: 1.625rem;
}

.edition-banner__description :deep(p) {
  margin: 0;
}

.edition-banner__cta {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 2.75rem;
  padding: 0 1.25rem;
  border-radius: 0.375rem;
  background: var(--ui-primary);
  color: var(--ui-text-inverted);
  font-weight: 700;
  text-decoration: none;
}

.edition-banner__cta:hover {
  background: color-mix(in srgb, var(--ui-primary) 86%, black);
}

@media (min-width: 640px) {
  .edition-banner {
    width: calc(100% - 3rem);
  }
}

@media (min-width: 1024px) {
  .edition-banner {
    width: calc(100% - 6rem);
  }

  .edition-banner__inner {
    padding: 4rem 2rem;
  }

  .edition-banner__title {
    font-size: 1.875rem;
    line-height: 2.25rem;
  }
}
</style>
