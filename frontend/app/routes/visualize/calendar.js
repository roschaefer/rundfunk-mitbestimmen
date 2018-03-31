import Route from '@ember/routing/route';
import fetch from 'fetch';

export default Route.extend({
  model() {
    const host = this.store.adapterFor('summarized-statistic').get('host');
    return fetch(`${host}/chart_data/calendar`).then(function(response) {
      return response.json();
    });
  }
});
