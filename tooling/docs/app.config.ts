export default defineAppConfig({
  header: {
    title: 'Dashboard Store docs'
  },
  socials: {
    github: 'Sciance-Inc/core.dashboards_store'
  },
  github: {
    owner: 'Sciance-Inc',
    name: 'core.dashboards_store',
    url: 'https://github.com/Sciance-Inc/core.dashboards_store',
    branch: 'develop',
    rootDir: 'tooling/docs/content/en',
    edit: true
  },
  toc: {
    bottom: {
      title: 'Community',
      links: [
        {
          label: 'Sciance',
          to: 'https://sciance.ca',
          target: '_blank'
        },
        {
          label: 'GitHub',
          to: 'https://github.com/Sciance-Inc/core.dashboards_store',
          target: '_blank'
        }
      ]
    }
  },
  footer: {
    credits: {
      text: 'Powered by Sciance Inc.',
      href: 'https://sciance.ca'
    }
  },
  ui: {
    colors: {
      primary: 'blue',
      neutral: 'zinc'
    }
  }
})
