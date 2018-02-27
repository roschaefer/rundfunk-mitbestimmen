import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Route.extend(ResetScrollPositionMixin, {
  model(){
    return this.store.findAll('statistic/broadcast-history');
  }
});
