import Ember from 'ember';
import ENV from 'frontend/config/environment';
// app/routes/application.js
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin , {
  intl: Ember.inject.service(),
  routeAfterAuthentication: 'login',
  beforeModel() {
    // define the app's runtime locale
    // For example, here you would maybe do an API lookup to resolver
    // which locale the user should be targeted and perhaps lazily
    // load translations using XHR and calling intl's `addTranslation`/`addTranslations`
    // method with the results of the XHR request

    // whatever you do to pick a locale for the user:
    return this.get('intl').setLocale(calculateLocale());

    // OR for those that sideload, an array is accepted to handle fallback lookups

    // en-ca is the primary locale, en-us is the fallback.
    // this is optional, and likely unnecessary if you define baseLocale (see below)
    // The primary usecase is if you side load all translations
    //
    // return this.get('intl').setLocale(['en-ca', 'en-us']);
  },
  actions: {
    login () {
      const lang = this.get('intl').get('locale')[0];
      let lockOptions = {
        socialBigButtons: true,
        dict: lang,
        authParams: {
          state: this.get('router.url'),
          scope: 'openid email'
        }
      };
      this.get('session').authenticate(ENV.APP.authenticator, lockOptions);
    },

    logout () {
      this.get('session').invalidate();
    }
  }
});

function calculateLocale(){
  const locale = navigator.language || navigator.userLanguage || 'de';
  const lang = locale.split('-')[0];
  return lang;
}
