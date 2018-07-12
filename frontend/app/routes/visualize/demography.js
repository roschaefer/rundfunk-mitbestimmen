import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import { inject as service } from '@ember/service';

export default Route.extend(ResetScrollPositionMixin, {
  store: service(),
  session: service(),

  model() {
    if (this.get('session.isAuthenticated')) {
      return this.get('store').queryRecord('user', {});
    }
  }
});
