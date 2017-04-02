import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  session: Ember.inject.service('session'),
  beforeModel() {
    this._super(...arguments);
    if (window._paq){
      window._paq.push(['trackGoal', 4]);
      //goalId 4 is "Signup/Login successful"
    }
    this.store.findRecord('condensed-balance', 0, {reload: true}).then(() => {
      // make a random request to the database, the user will be saved to the
      // datatabase and all subsequent request will be associated to that user
      return Ember.RSVP.allSettled(this.store.peekAll('selection').map((s) => {
        return s.save();
      })).finally(() => {
        const encodedState = this.get('session').get('data.authenticated.state');
        console.log(encodedState);
        let toRoute;
        if (encodedState) {
          const state = JSON.parse(atob(this.get('session').get('data.authenticated.state')));
          console.log(state);
          toRoute = state.toRoute;
        } else {
          toRoute = '/';
        }
        console.log(toRoute);
        return this.transitionTo(toRoute);
      });
    });
  }
});
