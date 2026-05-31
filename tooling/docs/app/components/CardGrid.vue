<script setup lang="ts">
defineProps({
  title: {
    type: String,
    default: 'Features'
  }
})
</script>

<template>
  <section class="card-grid">
    <slot name="root" />

    <div class="card-grid__title">
      <slot name="title">
        {{ title }}
      </slot>
    </div>

    <div class="card-grid__layout">
      <slot />
    </div>
  </section>
</template>

<style scoped>
.card-grid {
  position: relative;
  box-sizing: border-box;
  width: 100%;
  max-width: 80rem;
  margin-inline: auto;
  padding: 0 1rem 5rem;
}

.card-grid__title {
  margin-bottom: 2rem;
  color: rgb(24 24 27);
  font-size: 2.25rem;
  font-weight: 800;
  line-height: 2.5rem;
}

.card-grid__title :deep(p) {
  margin: 0;
}

.card-grid__layout {
  display: grid;
  gap: 1rem;
}

@media (min-width: 640px) {
  .card-grid {
    padding: 0 1.5rem 6rem;
  }

  .card-grid__layout {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (min-width: 1024px) {
  .card-grid {
    padding: 0 2rem 8rem;
  }

  .card-grid__layout {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}
</style>
