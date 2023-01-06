module.exports = {
  ci: {
    collect: {
      startServerCommand: "npm run start",
      numberOfRuns: 3,
      url: ["https://www.ciencuadras.com/"],
      chromePath: "/usr/bin/google-chrome",
    },
    assert: {
      assertions: {
        "categories:performance": ["error", { minScore: 99 }],
        "categories:accessibility": ["error", { minScore: 99 }],
        "categories:best-practices": ["error", { minScore: 99 }],
        "categories:seo": ["error", { minScore: 99 }],
        "categories.pwa": "off",
      },
    },
    upload: {
      target: "temporary-public-storage",
    },
  },
};
