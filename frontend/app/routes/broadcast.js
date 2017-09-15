import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, ResetScrollPositionMixin, {
  model(params) {
    return this.get('store').findRecord('broadcast', params.broadcast_id);
  }
});
