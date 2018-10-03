import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';
import ENV from 'frontend/config/environment';

export default Route.extend({
  intl: service(),
  raven: service(),
  fastboot: service(),
  session: service(),
  auth0: service(),
  store: service(),
  routeAfterAuthentication: 'authentication.callback', // for testing environment
  beforeModel() {
    this._super(...arguments);

    const lastLocale = this.get('session.data.locale');
    if(lastLocale){
      return this.get('intl').setLocale(lastLocale);
    }

    let locale
    let lang

    if (this.get('fastboot.isFastBoot')) {
      let headers = this.get('fastboot.request.headers');
      locale = headers.get('Accept-Language');
    } else {
      locale = navigator.language || navigator.userLanguage || 'en';
    }
    lang = locale.split('-')[0];

    if (!['de', 'en'].includes(lang)){
      lang = 'en'
    }
    return this.get('intl').setLocale(lang);

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

      if (ENV.APP.authenticator === 'authenticator:stub') {
        return this.transitionTo('authentication.callback');
      }
      this.get('auth0.webAuth').authorize({ language: this.get('intl.locale.firstObject') });
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
