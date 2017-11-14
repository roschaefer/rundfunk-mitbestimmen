module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'frontend',
    environment: environment,
    rootURL: '/',
    locationType: 'auto',
    contentSecurityPolicy: {
        'font-src': "'self' data: https://cdn.auth0.com fonts.gstatic.com",
        'style-src': "'self' 'unsafe-inline' fonts.googleapis.com",
        'script-src': "'self' 'unsafe-eval' 'unsafe-inline' https://cdn.auth0.com cdn.ravenjs.com",
        'img-src': "data: sentry.io",
        'connect-src': "'self' http://localhost:* api.rundfunk-mitbestimmen.de rundfunk-mitbestimmen.eu.auth0.com sentry.io"
    },
    'ember-simple-auth': {
      auth0: {
        clientID: (process.env.AUTH0_CLIENT_ID || "3NSVbVwiVABkv6uS7vRzH0sY7mqmlzOG"),
        domain: (process.env.AUTH0_DOMAIN || "rundfunk-testing.eu.auth0.com")
      },
    },
    sentry: {
      dsn: 'https://fa04a98e51af49bb8309bf73fc9096d0@sentry.io/244938'
    },
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },
    EXTEND_PROTOTYPES: {
      // Prevent Ember Data from overriding Date.parse.
      Date: false
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
      BACKEND_URL: (process.env.API_HOST || 'http://localhost:3000'),
      authenticator: 'authenticator:auth0-lock-passwordless'
    },
    metricsAdapters: [
      {
        name: 'Piwik',
        environments: ['development', 'production'],
        config: {
          piwikUrl: 'https://piwik.rundfunk-mitbestimmen.de',
          siteId: 1
        }
      }
    ],
    googleFonts: [
      'Assistant:400,700'
    ],
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
    ENV.APP.BACKEND_URL = 'http://localhost:3001'; // don't send requests to rails by accident
  }

  if ((environment === 'integration') || (environment === 'fullstack')) {
    ENV.APP.authenticator = 'authenticator:stub-authenticator';
  }

  if (environment === 'staging') {
    ENV.APP.BACKEND_URL = 'https://rundfunk-backend.roschaefer.de/';
  }

  if (environment === 'production') {
    ENV.APP.BACKEND_URL = 'https://api.rundfunk-mitbestimmen.de/';
    ENV['ember-simple-auth']['auth0'] = {
      clientID: 'JRtwcxWPTYEFnTGHQBVTGI3kl8dfIH0Q',
      domain: 'rundfunk-mitbestimmen.eu.auth0.com'
    };
  }

  return ENV;
};
