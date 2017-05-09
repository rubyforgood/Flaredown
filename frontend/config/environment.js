/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    rootURL: '/',
    environment: environment,
    modulePrefix: 'flaredown',
    locationType: 'router-scroll',
    historySupportMiddleware: true,

    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    torii: {
      providers: {
        'facebook-connect': {
          appId: process.env.FACEBOOK_APP_ID,
          version: 'v2.5'
        }
      }
    },

    pusher: {
      'key': process.env.PUSHER_KEY
    },

    userEngage: {
      apiKey: process.env.USERENGAGE_API_KEY
    },

    gReCaptcha: {
      siteKey: process.env.RECAPTCHA_SITE_KEY
    },

    'full-story': {
      enabled: process.env.FULLSTORY_ENABLED === 'true',
      org: process.env.FULLSTORY_ORG
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },

    i18n: {
      defaultLocale: 'en',
    },
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {
    ENV['heap-analytics'] = {
      key: process.env.HEAP_KEY,
    };
  }

  return ENV;
};
