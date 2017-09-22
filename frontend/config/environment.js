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

    fastboot: {
      hostWhitelist: ['flaredown-webapp.herokuapp.com', 'staging.flaredown.com', 'app.flaredown.com', 'flaredown-staging-webapp.herokuapp.com', /^localhost:\d+$/]
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

    review: {
      appStore: 'https://itunes.apple.com/app/id982963596?action=write-review',
      googlePlay: 'https://play.google.com/store/apps/details?id=com.flaredown.flaredownWebWrapper',
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
    ENV.apiHost = 'http://localhost:3000';
    var STATIC_URL = 'http://localhost:4300';
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
    ENV.apiHost = 'http://localhost:3000';
    var STATIC_URL = 'http://localhost:4300';
  }

  if (environment === 'production') {
    ENV['heap-analytics'] = {
      key: process.env.HEAP_KEY,
    };

    ENV.apiHost = process.env.API_HOST;
    var STATIC_URL = process.env.STATIC_URL;

    ENV.airbrake = {
      host: process.env.AIRBRAKE_HOST,
      projectId: process.env.AIRBRAKE_PROJECT_ID,
      projectKey: process.env.AIRBRAKE_PROJECT_KEY,
    }
  }

  ENV.staticUrl = STATIC_URL;

  return ENV;
};
