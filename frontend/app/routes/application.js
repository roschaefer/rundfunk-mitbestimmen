import Ember from 'ember';
import ENV from 'frontend/config/environment';
// app/routes/application.js
import ApplicationRouteMixin from 'ember-simple-auth-auth0/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin , {
  intl: Ember.inject.service(),
  routeAfterAuthentication: 'authentication.callback', // for testing environment
  beforeModel() {
    // define the app's runtime locale
    // For example, here you would maybe do an API lookup to resolver
    // which locale the user should be targeted and perhaps lazily
    // load translations using XHR and calling intl's `addTranslation`/`addTranslations`
    // method with the results of the XHR request

    // whatever you do to pick a locale for the user:
    this._super(...arguments);
    return this.get('intl').setLocale(calculateLocale());

    // OR for those that sideload, an array is accepted to handle fallback lookups

    // en-ca is the primary locale, en-us is the fallback.
    // this is optional, and likely unnecessary if you define baseLocale (see below)
    // The primary usecase is if you side load all translations
    //
    // return this.get('intl').setLocale(['en-ca', 'en-us']);
  },
  actions: {
    login (givenDict, afterLoginRoute) {
      const toRoute = afterLoginRoute || this.get('router.url');

      const dict = Object.assign({
          emailSent: {
            sentLabel: this.get('intl').t('auth0-lock.emailSent.sentLabel'),
            resendLabel: this.get('intl').t('auth0-lock.emailSent.resendLabel'),
            success: this.get('intl').t('auth0-lock.emailSent.success'),
          },
          networkOrEmail: {
            footerText: "",
            headerText: "",
            smallSocialButtonsHeader: this.get('intl').t('auth0-lock.networkOrEmail.smallSocialButtonsHeader'),
            separatorText: this.get('intl').t('auth0-lock.networkOrEmail.separatorText'),
          },
        title: this.get('intl').t('auth0-lock.title'),
      }, givenDict);

      // Check out the docs for all the options:
      // https://auth0.com/docs/libraries/lock/customization
      const lockOptions = {
        connections: ["facebook", "google-oauth2"],
        icon:  'https://rundfunk-mitbestimmen.de/assets/images/logo.png',
        primaryColor: '#2185D0',
        dict: dict,
        closable: false,
        authParams: {
          state: toRoute,
          scope: 'openid email',
        },
        socialBigButtons: false,
        responseType: 'token',
        callbackURL: window.location.origin + '/authentication/callback'
      };
      this.get('session').authenticate(ENV.APP.authenticator, 'socialOrMagiclink', lockOptions);
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
