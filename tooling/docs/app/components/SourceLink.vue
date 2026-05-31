<script setup lang="ts">
defineProps({
  path: {
    type: String,
    default: ''
  }
})
</script>

<template>
  <p class="source-link">
    <slot>
      <a v-if="path" :href="path" target="_blank" rel="noreferrer">Source</a>
    </slot>
  </p>
</template>

<style scoped>
.source-link {
  margin: 1rem 0;
  font-size: 0.875rem;
}
</style>
