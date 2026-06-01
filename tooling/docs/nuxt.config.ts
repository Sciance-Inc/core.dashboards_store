export default defineNuxtConfig({
  extends: ['docus'],

  modules: ['@nuxtjs/i18n'],

  site: {
    name: 'Dashboard Store docs',
    url: 'https://docs.dashboards-store.sciance.ca'
  },

  i18n: {
    strategy: 'prefix',
    defaultLocale: 'fr',
    locales: [
      { code: 'fr', name: 'Français' },
      { code: 'en', name: 'English' }
    ]
  },

  routeRules: {
    '/': {
      redirect: '/fr'
    }
  },

  runtimeConfig: {
    public: {
      siteUrl: 'https://docs.dashboards-store.sciance.ca'
    }
  },

  appConfig: {
    github: {
      owner: 'Sciance-Inc',
      name: 'core.dashboards_store',
      url: 'https://github.com/Sciance-Inc/core.dashboards_store',
      branch: 'develop',
      rootDir: 'tooling/docs'
    }
  },

  app: {
    head: {
      htmlAttrs: {
        lang: 'fr'
      },
      link: [
        { rel: 'icon', href: '/favicon.ico' },
        { rel: 'canonical', href: 'https://docs.dashboards-store.sciance.ca/fr' }
      ]
    }
  },

  colorMode: {
    preference: 'light',
    fallback: 'light'
  },

  llms: {
    domain: 'https://docs.dashboards-store.sciance.ca',
    title: 'Dashboard Store docs',
    description: 'Documentation pour Dashboard Store.'
  },

  fonts: {
    providers: {
      adobe: false,
      bunny: false,
      fontshare: false,
      fontsource: false,
      google: false,
      googleicons: false,
      npm: false
    }
  },

  icon: {
    provider: 'server',
    serverBundle: {
      collections: ['lucide', 'simple-icons', 'vscode-icons']
    },
    clientBundle: {
      icons: [
        'lucide:alert-circle',
        'lucide:arrow-left',
        'lucide:arrow-right',
        'lucide:bookmark',
        'lucide:box',
        'lucide:chevron-down',
        'lucide:copy',
        'lucide:hash',
        'lucide:moon',
        'lucide:pen',
        'lucide:puzzle',
        'lucide:rocket',
        'lucide:search',
        'lucide:settings',
        'lucide:sun',
        'lucide:triangle',
        'simple-icons:github'
      ]
    }
  },

  ogImage: {
    enabled: false
  },

  vite: {
    build: {
      minify: false,
      reportCompressedSize: false,
      sourcemap: false
    }
  },

  nitro: {
    minify: false,
    sourceMap: false,
    prerender: {
      concurrency: 1,
      failOnError: false,
      routes: ['/fr', '/en']
    }
  }
})
