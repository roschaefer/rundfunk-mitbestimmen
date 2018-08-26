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
    let lang;
    if (this.get('fastboot.isFastBoot')) {
      let headers = this.get('fastboot.request.headers');
      lang = headers.get('Accept-Language');
    } else {
      const locale = navigator.language || navigator.userLanguage || 'en';
      lang = locale.split('-')[0];
    }
    return ['de', 'en'].includes(lang) ? lang : 'en';
  }),
  routeAfterAuthentication: 'authentication.callback', // for testing environment
  beforeModel() {
    this._super(...arguments);
    this.get('intl').setLocale(this.get('currentLocale'));
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

