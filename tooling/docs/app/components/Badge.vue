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
  border-color: rgb(147 197 253);
  background: rgb(239 246 255);
  color: rgb(30 64 175);
}

.badge--success {
  border-color: rgb(134 239 172);
  background: rgb(240 253 244);
  color: rgb(22 101 52);
}

.badge--warning {
  border-color: rgb(253 224 71);
  background: rgb(254 252 232);
  color: rgb(133 77 14);
}

.badge--danger {
  border-color: rgb(252 165 165);
  background: rgb(254 242 242);
  color: rgb(153 27 27);
}
</style>
