import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';

export default Ember.Route.extend(ResetScrollPositionMixin, {
  model() {
    return RSVP.hash({
      tv: this.store.findRecord('chart-data/diff', 0),
      radio: this.store.findRecord('chart-data/diff', 1)
    });
  }
});
