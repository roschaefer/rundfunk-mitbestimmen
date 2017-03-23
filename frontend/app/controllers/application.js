//app/controllers/application.js
import Ember from 'ember';

export default Ember.Controller.extend({
  intl: Ember.inject.service(),
  session: Ember.inject.service('session'),
  actions: {
    login (afterLoginRoute) {
      const lang = this.get('intl').get('locale')[0];
      // Check out the docs for all the options:
      // https://auth0.com/docs/libraries/lock/customization
      const lockOptions = {
        theme: {
          logo:  'https://rundfunk-mitbestimmen.de/assets/images/logo.png'
        },
        language: lang,
        auth: {
          autoclose: true,
          redirect: false,
          responseType: 'token',
          redirectUrl: 'http://localhost:4200/login',
          params: {
            state: (afterLoginRoute || this.get('router.url')),
            scope: 'openid email',
          }
        }
      };

      this.get('session').authenticate('authenticator:auth0-lock', lockOptions);
    },

    logout () {
      this.get('session').invalidate();
    }
  }
});
