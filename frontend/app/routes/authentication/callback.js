import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  session: Ember.inject.service('session'),
  model() {
    if (window._paq){
      window._paq.push(['trackGoal', 4]);
      //goalId 4 is "Signup/Login successful"
    }
    return this.store.findRecord('condensed-balance', 0, {reload: true}).then(() => {
      // make a random request to the database, the user will be saved to the
      // datatabase and all subsequent request will be associated to that user
      const state = JSON.parse(atob(this.get('session').get('data.authenticated.state')));

      return Ember.RSVP.allSettled(state.selections.map((s) => {
        return this.store.findRecord('broadcast', s.broadcast).then((b) => {
          let selection = this.store.createRecord('selection', s);
          selection.set('broadcast', b);
          return selection.save();
        });
      })).finally(() => {
        return this.transitionTo(state.toRoute);
      });
    });
  }
});
