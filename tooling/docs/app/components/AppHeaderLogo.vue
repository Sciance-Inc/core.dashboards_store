<template>
  <span class="app-header-logo">
    <!-- Light mode: dark-ink wordmark -->
    <img src="/logo.png" alt="Dashboard Store" class="h-[29px] w-auto block dark:hidden">
    <!-- Dark mode: white wordmark -->
    <img src="/logo-dark.webp" alt="Dashboard Store" class="h-[29px] w-auto hidden dark:block">
  </span>
</template>

<style scoped>
.app-header-logo {
  display: inline-flex;
  align-items: center;
}
</style>
