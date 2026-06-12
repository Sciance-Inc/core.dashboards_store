<script setup lang="ts">
// "Contact an expert" call-to-action shown in the site header on every page.
//
// Shadows the empty Docus `AppHeaderCTA` stub (the theme's intended header
// extension point, rendered first in the header's right cluster), so no fork
// of AppHeader.vue is needed. Bilingual via useDocusI18n(), same pattern as
// the LanguageSelect override.
//
// Sciance contact details — edit here.
const CONTACT = {
  generalEmail: 'info@sciance.ca',
  experts: [
    { name: 'Hugo Juhel', email: 'juhel.hugo@sciance.ca' },
    { name: 'Éric Marcotte', email: 'emarcotte@sciance.ca' },
  ],
  phoneLabel: '+1 (514) 250-0945',
  phoneHref: 'tel:+15142500945',
  // Group chat with both experts. External-client reach depends on the org's
  // Teams external-access (federation) settings.
  teamsHref: 'https://teams.microsoft.com/l/chat/0/0?users=juhel.hugo@sciance.ca,emarcotte@sciance.ca',
}

const { locale } = useDocusI18n()
const fr = computed(() => (locale.value || 'fr').startsWith('fr'))
const t = computed(() => fr.value
  ? { label: 'Contacter un expert', heading: 'Parlez à un expert Sciance', team: 'Équipe Sciance', teams: 'Clavarder sur Teams' }
  : { label: 'Contact an expert', heading: 'Talk to a Sciance expert', team: 'Sciance team', teams: 'Chat on Teams' })
</script>

<template>
  <UPopover :content="{ align: 'end' }">
    <UButton
      color="neutral"
      variant="ghost"
      size="sm"
      icon="i-lucide-user-round"
      trailing-icon="i-lucide-chevron-down"
      :aria-label="t.label"
    >
      <span class="hidden sm:inline">{{ t.label }}</span>
    </UButton>

    <template #content>
      <div class="p-1 w-64">
        <p class="px-2 py-1.5 text-xs font-semibold text-muted">
          {{ t.heading }}
        </p>
        <ul class="flex flex-col">
          <li>
            <NuxtLink
              :to="`mailto:${CONTACT.generalEmail}`"
              class="flex items-center gap-2.5 py-1.5 px-2 rounded-md hover:bg-muted"
            >
              <UIcon name="i-lucide-mail" class="size-4 text-muted shrink-0" />
              <span class="flex flex-col leading-tight">
                <span class="text-sm">{{ t.team }}</span>
                <span class="text-xs text-muted">{{ CONTACT.generalEmail }}</span>
              </span>
            </NuxtLink>
          </li>
          <li
            v-for="expert in CONTACT.experts"
            :key="expert.email"
          >
            <NuxtLink
              :to="`mailto:${expert.email}`"
              class="flex items-center gap-2.5 py-1.5 px-2 rounded-md hover:bg-muted"
            >
              <UIcon name="i-lucide-mail" class="size-4 text-muted shrink-0" />
              <span class="flex flex-col leading-tight">
                <span class="text-sm">{{ expert.name }}</span>
                <span class="text-xs text-muted">{{ expert.email }}</span>
              </span>
            </NuxtLink>
          </li>
          <li>
            <NuxtLink
              :to="CONTACT.phoneHref"
              class="flex items-center gap-2.5 py-1.5 px-2 rounded-md hover:bg-muted"
            >
              <UIcon name="i-lucide-phone" class="size-4 text-muted shrink-0" />
              <span class="text-sm">{{ CONTACT.phoneLabel }}</span>
            </NuxtLink>
          </li>
          <li>
            <NuxtLink
              :to="CONTACT.teamsHref"
              target="_blank"
              rel="noopener"
              class="flex items-center gap-2.5 py-1.5 px-2 rounded-md hover:bg-muted"
            >
              <UIcon name="i-simple-icons-microsoftteams" class="size-4 text-muted shrink-0" />
              <span class="text-sm">{{ t.teams }}</span>
            </NuxtLink>
          </li>
        </ul>
      </div>
    </template>
  </UPopover>
</template>
