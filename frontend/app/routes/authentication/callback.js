import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import ENV from 'frontend/config/environment';

export default Route.extend({
  session: service(),
  intl: service(),
  fastboot: service(),
  model() {
    if (!this.get('fastboot.isFastBoot')){
      return this.get('session').authenticate(ENV.APP.authenticator).then(() => {
        if (window._paq){
          window._paq.push(['trackGoal', 4]);
          //goalId 4 is "Signup/Login successful"
        }

        return this.store.queryRecord('user', {reload: true}).then((user) => {
          const locale = user.get('locale');
          if (locale) {
            this.get('intl').setLocale(locale);
            this.get('session').set('data.locale', locale)
          }
          const state = this.get('session.data.afterLoginRoute') || '/';
          return this.transitionTo(state);
        });
      });
    }
  }
});
