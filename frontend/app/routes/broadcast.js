import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, ResetScrollPositionMixin, {
  model(params) {
    return this.get('store').findRecord('broadcast', params.broadcast_id);
  },
  actions: {
    error(error) {
      if (error.errors.isAny('status', '404')) {
        this.transitionTo('/404'); // '404' gives a name error, why??
      } else {
        // Let the route above this handle the error.
        return true;
      }
    }
  }
});
