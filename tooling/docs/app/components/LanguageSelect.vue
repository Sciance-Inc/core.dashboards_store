<script setup lang="ts">
// Bilingual language toggle following the Government of Canada language-toggle
// pattern: a plain text link to the OTHER official language, labelled in its
// own native name. No country flags — flags represent countries, not languages,
// and France's/Britain's flags don't belong on a Québec product.
//
// This shadows the Docus built-in `LanguageSelect.vue` via Nuxt layer
// resolution (same component name, app layer wins over the extended theme).
const { locale, locales, switchLocalePath } = useDocusI18n()

type Locale = { code: string, name: string }

// `locales` is a plain array; `locale` is a ref of the active code.
const otherLocales = computed(() =>
  (locales as Locale[]).filter(item => item.code !== locale.value),
)
</script>

<template>
  <UButton
    v-for="item in otherLocales"
    :key="item.code"
    :to="switchLocalePath(item.code) as string"
    :lang="item.code"
    :aria-label="item.name"
    :label="item.name"
    color="neutral"
    variant="ghost"
    size="sm"
    icon="i-lucide-languages"
  />
</template>
