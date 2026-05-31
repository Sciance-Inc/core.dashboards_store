<script setup lang="ts">
defineProps({
  width: {
    type: String,
    default: '10rem'
  },
  height: {
    type: String,
    default: '10rem'
  },
  top: {
    type: String,
    default: '0'
  },
  left: {
    type: String,
    default: 'auto'
  },
  right: {
    type: String,
    default: 'auto'
  },
  blur: {
    type: String,
    default: '50px'
  }
})
</script>

<template>
  <div class="ellipsis" aria-hidden="true">
    <div />
  </div>
</template>

<style scoped>
.ellipsis {
  pointer-events: none;
  position: absolute;
  top: v-bind(top);
  left: v-bind(left);
  right: v-bind(right);
  z-index: -1;
  width: min(v-bind(width), 100%);
  height: v-bind(height);
  filter: blur(v-bind(blur));
  opacity: 0.72;
}

.ellipsis > div {
  width: 100%;
  height: 100%;
  background: linear-gradient(98deg, rgb(0 71 225 / 0.2), rgb(26 214 255 / 0.18), rgb(0 220 130 / 0.18));
}
</style>
