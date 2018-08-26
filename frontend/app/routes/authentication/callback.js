import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default Route.extend({
  session: service(),
  intl: service(),
  fastboot: service(),
  model() {
    return this.get('session').authenticate('authenticator:auth0').then((data) => {
      if (!this.get('fastboot.isFastBoot') && window._paq){
        window._paq.push(['trackGoal', 4]);
        //goalId 4 is "Signup/Login successful"
      }

      return this.store.queryRecord('user', {reload: true}).then((user) => {
        const locale = user.get('locale');
        if (locale) {
          this.get('intl').setLocale(locale);
        }
        const state = this.get('session.data.afterLoginRoute') || '/';
        return this.transitionTo(state);
      });
    });
  }
});
