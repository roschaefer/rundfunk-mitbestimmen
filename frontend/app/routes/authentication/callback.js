import Route from '@ember/routing/route';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import { inject as service } from '@ember/service';

export default Route.extend(AuthenticatedRouteMixin, {
  session: service(),
  intl: service(),
  model() {
    if (window._paq){
      window._paq.push(['trackGoal', 4]);
      //goalId 4 is "Signup/Login successful"
    }
    return this.store.queryRecord('user', {reload: true}).then((user) => {
      const locale = user.get('locale');
      if (locale) {
        this.get('intl').setLocale(locale);
      }
      const state = this.get('session').get('data.afterLoginRoute') || '/';
      return this.transitionTo(state);
    });
  }
});
