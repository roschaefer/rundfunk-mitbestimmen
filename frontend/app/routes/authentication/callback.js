import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  session: Ember.inject.service('session'),
  intl: Ember.inject.service(),
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
      const state = this.get('session').get('data.authenticated.state') || '/';
      return this.transitionTo(state);
    });
  }
});
