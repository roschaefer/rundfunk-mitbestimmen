import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Ember.Route.extend(ResetScrollPositionMixin, {
  model(params) {
    return this.store.findRecord('broadcast', params.broadcast_id);
  }
});
