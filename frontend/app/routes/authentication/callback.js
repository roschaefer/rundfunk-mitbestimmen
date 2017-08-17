import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  session: Ember.inject.service('session'),
  model() {
    if (window._paq){
      window._paq.push(['trackGoal', 4]);
      //goalId 4 is "Signup/Login successful"
    }
    return this.store.queryRecord('summarized-statistic', {reload: true}).then(() => {
      // make a random request to the database, the user will be saved to the
      // datatabase and all subsequent request will be associated to that user
      const state = this.get('session').get('data.authenticated.state');
      return this.transitionTo(state);
    });
  }
});
