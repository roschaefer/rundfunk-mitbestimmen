import Ember from 'ember';
import RSVP from 'rsvp';

export default Ember.Route.extend({
  model() {
    return RSVP.hash({
      tv: this.store.findRecord('chart-data/diff', 0),
      radio: this.store.findRecord('chart-data/diff', 1)
    });
  }
});
