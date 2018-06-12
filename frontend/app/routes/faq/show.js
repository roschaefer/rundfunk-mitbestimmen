import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Route.extend(ResetScrollPositionMixin, {
  model(params) {
    return params.slug
  }
});
