import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.findRecord('summarized-statistic', 0);
  }
});
