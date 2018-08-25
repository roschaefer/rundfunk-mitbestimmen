import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import Route from '@ember/routing/route';
import ENV from 'frontend/config/environment';
// app/routes/application.js
import ApplicationRouteMixin from 'ember-simple-auth-auth0/mixins/application-route-mixin';

export default Route.extend(ApplicationRouteMixin , {
  intl: service(),
  raven: service(),
  fastboot: service(),
  currentLocale: computed('fastboot', function() {
    if (this.get('fastboot.isFastBoot')) return 'de';
    const locale = navigator.language || navigator.userLanguage || 'en';
    const lang = locale.split('-')[0];
    return ['de', 'en'].includes(lang) ? lang : 'en';
  }),
  routeAfterAuthentication: 'authentication.callback', // for testing environment
  beforeModel() {
    // define the app's runtime locale
    // For example, here you would maybe do an API lookup to resolver
    // which locale the user should be targeted and perhaps lazily
    // load translations using XHR and calling intl's `addTranslation`/`addTranslations`
    // method with the results of the XHR request

    // whatever you do to pick a locale for the user:
    this._super(...arguments);
    return this.get('intl').setLocale(this.get('currentLocale'));

    // OR for those that sideload, an array is accepted to handle fallback lookups

    // en-ca is the primary locale, en-us is the fallback.
    // this is optional, and likely unnecessary if you define baseLocale (see below)
    // The primary usecase is if you side load all translations
    //
    // return this.get('intl').setLocale(['en-ca', 'en-us']);
  },
  actions: {
    login (afterLoginRoute) {
      this.get('session').set('data.afterLoginRoute', afterLoginRoute || this.get('router.url'));
      const dict = {
        title: this.get('intl').t('auth0-lock.title'),
        success: {
          magicLink: this.get('intl').t('auth0-lock.success.magicLink'),
        },
        socialLoginInstructions: this.get('intl').t('auth0-lock.socialLoginInstructions'),
        passwordlessEmailAlternativeInstructions: this.get('intl').t('auth0-lock.passwordlessEmailAlternativeInstructions'),
        lastLoginInstructions: this.get('intl').t('auth0-lock.lastLoginInstructions'),
      };

      const lockOptions = {
        allowedConnections: ['email', 'facebook', 'google-oauth2', 'twitter'],
        passwordlessMethod: 'link',
        theme:{
          logo:  '/assets/images/logo.png',
          primaryColor: '#2185D0',
        },
        socialButtonStyle: 'small',
        language: this.get('intl.locale.firstObject'),
        languageDictionary: dict,
        auth: {
          params: {
            scope: 'openid email',
          },
          responseType: 'token',
          redirectUrl: window.location.origin + '/authentication/callback'
        }
      };
      this.get('session').authenticate(ENV.APP.authenticator, lockOptions);
    },

    logout () {
      this.get('session').invalidate();
    },

    error(error){
      if(!ENV['sentry']['development']) {
        this.get('raven').captureException(error)
      }
      return true; // Let the route above this handle the error.
    }
  }
});

