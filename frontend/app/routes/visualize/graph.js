import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Route.extend(ResetScrollPositionMixin, {
  model() {
    const host = this.store.adapterFor('summarized-statistic').get('host');
    return fetch(`${host}/chart_data/similarities.json`).then(function(response) {
        return response.json();
      });
    }
  }
);
