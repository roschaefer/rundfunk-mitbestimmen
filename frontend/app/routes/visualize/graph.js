import { inject as service } from '@ember/service';
import fetch from 'fetch';
import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Route.extend(ResetScrollPositionMixin, {
    intl: service(),
    session: service(),
    queryParams: {
      specificToUser: {
        refreshModel: true
      }
    },

    model(params) {
      const host = this.store.adapterFor('summarized-statistic').get('host');
      let url = new URL(`${host}/chart_data/similarities.json`);
      if (params.specificToUser){
        url.searchParams.append('specific_to_user', params.specificToUser);
      }

      return fetch(url).then(function(response) {
        return response.json();
      });
    },
    actions: {
      toggleSpecificToUser(currentValue){
        const switchedValue = currentValue != "true";
        this.transitionTo({ queryParams: { specific_to_user: switchedValue }});
      }
    }
  }
);
