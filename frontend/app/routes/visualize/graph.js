import { inject as service } from '@ember/service';
import fetch from 'fetch';
import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Route.extend(ResetScrollPositionMixin, {
    intl: service(),
    session: service(),

    model(params) {
      const host = this.store.adapterFor('summarized-statistic').get('host');
      let fullUrl = `${host}/chart_data/similarities.json`;

      params.specific_to_user = params.specific_to_user == 'true'

      if(params.specific_to_user){
        fullUrl += `?specific_to_user=true`;
      }

      return fetch(fullUrl).then(function(response) {
        return response.json();
      });
    },
    queryParams: {
      specific_to_user: {
        refreshModel: true
      }
    },
    actions: {
      toggleSpecificToUser(currentValue){
        const switchedValue = currentValue != "true";
        this.transitionTo({ queryParams: { specific_to_user: switchedValue }});
      }
    }
  }
);
