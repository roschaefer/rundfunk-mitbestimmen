import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.findRecord('condensed-balance', 0);
  }
});
