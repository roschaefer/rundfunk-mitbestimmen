import { inject as service } from '@ember/service';
import fetch from 'fetch';
import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import URL from 'url';
import RSVP from 'rsvp';

export default Route.extend(ResetScrollPositionMixin, {
  intl: service(),
  session: service(),
  queryParams: {
    specificToUser: {
      refreshModel: true
    }
  },

  init(){
    this._super(...arguments);
    this.get('intl').addObserver('locale', () =>  {
      this.refresh();
    });
  },

  model(params) {
    const host = this.store.adapterFor('summarized-statistic').get('host');
    let url = new URL(`${host}/chart_data/similarities.json`);
    let headers = {};
    if (this.get('session.isAuthenticated') && params.specificToUser){
      url.searchParams.append('specific_to_user', params.specificToUser);
      headers['Authorization'] = `Bearer ${this.get('session.data.authenticated.idToken')}`;
    }

    const model = {
      graph: fetch(url, {headers: headers}).then(function(response) {
        return response.json();
      }),
      media: this.store.findAll('medium')
    }
    return RSVP.hash(model);
  }
});
