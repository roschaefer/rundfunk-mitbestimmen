import Ember from 'ember';
import RouteMixin from 'ember-cli-pagination/remote/route-mixin';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Ember.Route.extend(RouteMixin, ResetScrollPositionMixin, {
  queryParams: {
    column: {
      refreshModel: true
    },
    direction: {
      refreshModel: true
    }
  },
  model: function(params) {
    // todo is your model name
    // returns a PagedRemoteArray
    params.paramMapping = {
      total_pages: "total-pages"
    };
    return this.findPaged('statistic/broadcast', params);
  }
});
