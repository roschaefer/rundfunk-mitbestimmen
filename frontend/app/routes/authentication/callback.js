import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  session: Ember.inject.service('session'),
  model() {
    if (window._paq){
      window._paq.push(['trackGoal', 4]);
      //goalId 4 is "Signup/Login successful"
    }
    return this.store.findRecord('summarized-statistic', 0, {reload: true}).then(() => {
      // make a random request to the database, the user will be saved to the
      // datatabase and all subsequent request will be associated to that user
      const state = JSON.parse(atob(this.get('session').get('data.authenticated.state')));

      return Ember.RSVP.allSettled(state.selections.map((s) => {
        // magic numbers FTW!
        return this.store.findRecord('broadcast', s[0]).then((b) => {
          let selection = this.store.createRecord('selection', {
            response: s[1],
            broadcast: b
          });
          return selection.save();
        });
      })).finally(() => {
        return this.transitionTo(state.toRoute);
      });
    });
  }
});
