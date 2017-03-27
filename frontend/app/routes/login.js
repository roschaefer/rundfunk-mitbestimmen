import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  session: Ember.inject.service('session'),
  beforeModel() {
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
        const toRoute = this.get('session').get('data.authenticated.state') || '/';
        return this.transitionTo(toRoute);
      });
    });
  }
});
