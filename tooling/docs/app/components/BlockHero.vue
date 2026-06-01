<script setup lang="ts">
import type { PropType } from 'vue'

defineProps({
  home: {
    type: Boolean,
    default: false
  },
  cta: {
    type: Array as PropType<string[]>,
    default: () => []
  },
  secondary: {
    type: Array as PropType<string[]>,
    default: () => []
  }
})
</script>

<template>
  <section :class="['block-hero', { 'block-hero--home': home }]">
    <div class="block-hero__layout">
      <div class="block-hero__content">
        <div v-if="$slots.title" class="block-hero__title">
          <slot name="title" />
        </div>

        <div v-if="$slots.description" class="block-hero__description">
          <slot name="description" />
        </div>

        <div v-if="$slots.extra" class="block-hero__extra">
          <slot name="extra" />
        </div>

        <div class="block-hero__actions">
          <slot name="actions">
            <NuxtLink v-if="cta.length >= 2" class="block-hero__cta" :to="cta[1]">
              {{ cta[0] }}
            </NuxtLink>
            <NuxtLink v-if="secondary.length >= 2" class="block-hero__secondary" :to="secondary[1]">
              {{ secondary[0] }}
            </NuxtLink>
          </slot>
        </div>
      </div>

      <div class="block-hero__support">
        <slot name="support" />
      </div>
    </div>
  </section>
</template>

<style scoped>
.block-hero {
  position: relative;
  box-sizing: border-box;
  width: 100%;
  max-width: 80rem;
  margin-inline: auto;
  padding: 5rem 1rem;
  overflow-x: hidden;
}

.block-hero--home {
  width: calc(100% - 2rem);
  max-width: 72rem;
  padding-inline: 0;
}

.block-hero__layout {
  display: grid;
  width: 100%;
  min-width: 0;
  max-width: 100%;
  gap: 4rem;
}

.block-hero__content {
  width: 100%;
  min-width: 0;
  max-width: 100%;
}

.block-hero__title {
  margin-bottom: 2rem;
  color: var(--ui-text-highlighted);
  font-size: 2rem;
  font-weight: 800;
  line-height: 1.05;
  overflow-wrap: break-word;
}

.block-hero__title :deep(p) {
  margin: 0;
}

.block-hero__description {
  max-width: 44rem;
  margin-bottom: 3rem;
  color: var(--ui-text-muted);
  font-size: 1.125rem;
  line-height: 1.75rem;
  overflow-wrap: break-word;
}

.block-hero__description :deep(p) {
  margin: 0;
}

.block-hero__extra {
  display: flex;
  min-width: 0;
  margin-bottom: 4rem;
}

.block-hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem 1.5rem;
  align-items: center;
}

.block-hero__cta {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 2.75rem;
  padding: 0 1rem;
  border-radius: 0.375rem;
  background: var(--ui-primary);
  color: var(--ui-text-inverted);
  font-weight: 700;
  text-decoration: none;
}

.block-hero__cta:hover {
  background: color-mix(in srgb, var(--ui-primary) 86%, black);
}

.block-hero__secondary {
  color: var(--ui-text-muted);
  font-weight: 600;
  text-decoration: none;
}

.block-hero__secondary:hover {
  color: var(--ui-text-highlighted);
}

.block-hero__support {
  width: 100%;
  min-width: 0;
  max-width: 100%;
}

@media (min-width: 640px) {
  .block-hero {
    padding-inline: 1.5rem;
  }

  .block-hero--home {
    width: calc(100% - 3rem);
    padding-inline: 0;
  }

  .block-hero__title {
    font-size: 2.25rem;
  }
}

@media (min-width: 1024px) {
  .block-hero {
    padding: 8rem 2rem;
  }

  .block-hero--home {
    width: calc(100% - 6rem);
    padding-inline: 0;
  }

  .block-hero__layout {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
  }

  .block-hero__content {
    grid-column: span 2 / span 2;
  }

  .block-hero__title {
    font-size: 3.75rem;
    line-height: 1;
  }
}
</style>
