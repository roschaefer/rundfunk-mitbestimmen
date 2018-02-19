import fetch from 'fetch';
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';

export default Route.extend(ResetScrollPositionMixin, {
  session: service(),
  model() {
    const host = this.store.adapterFor('summarized-statistic').get('host');
    let model = {
      geojson: fetch(`${host}/chart_data/geo/geojson`).then(function(response) {
        return response.json();
      }),
      summarizedStatistic: this.store.queryRecord('summarized-statistic', {})
    };
    if (this.get('session.isAuthenticated')) {
      model.user = this.store.queryRecord('user', {});
    }
    return RSVP.hash(model);
  }
});
