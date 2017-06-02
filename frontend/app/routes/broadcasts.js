import Ember from 'ember';
import RouteMixin from 'ember-cli-pagination/remote/route-mixin';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, RouteMixin, ResetScrollPositionMixin, {
  model: function(params) {
    params.paramMapping = {
      total_pages: "total-pages"
    };
    params = Object.assign({
      filter: {
        review: 'reviewed',
      }
    }, params);
    return this.findPaged('broadcast', params);
  },
  setupController: function(controller, model) {
    // Call _super for default behavior
    this._super(controller, model);
    controller.set('media', this.store.findAll('medium'));
    controller.set('stations', this.store.findAll('station'));
  }
});
