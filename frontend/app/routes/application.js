import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import Route from '@ember/routing/route';
import ENV from 'frontend/config/environment';

export default Route.extend({
  intl: service(),
  raven: service(),
  fastboot: service(),
  session: service(),
  auth0: service(),
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
      // save the current route, assuming we're using the same browser and will have access to the old session
      this.get('session').set('data.afterLoginRoute', afterLoginRoute || this.get('router.url'));

      if (ENV.APP.authenticator === 'authenticator:auth0') {
        this.get('auth0.webAuth').authorize({ language: this.get('intl.locale.firstObject') });
      } else {
        this.get('session').authenticate(ENV.APP.authenticator);
      }
    },

    logout () {
      this.get('session').invalidate();
    },

    error(error){
      if(!ENV.sentry.development) {
        this.get('raven').captureException(error)
      }
      return true; // Let the route above this handle the error.
    }
  }
});

