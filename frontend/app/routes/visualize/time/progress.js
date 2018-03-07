import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Route.extend(ResetScrollPositionMixin, {
  model(params){
    return this.store.findRecord('broadcast', params.broadcast_id);
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
