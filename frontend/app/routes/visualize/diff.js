import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Ember.Route.extend(ResetScrollPositionMixin, {
  model() {
    return this.store.findRecord('chart-data/diff', 0);
  }
});
