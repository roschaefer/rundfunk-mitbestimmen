import fetch from 'fetch';
import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

export default Route.extend(ResetScrollPositionMixin, {
    model(params) {
      const host = this.store.adapterFor('summarized-statistic').get('host');
      let fullUrl = `${host}/chart_data/similarities.json`;

      params.userspecific = params.userspecific == 'true'

      if(params.userspecific){
        fullUrl += `?userspecific=true`;
      }

      return fetch(fullUrl).then(function(response) {
        return response.json();
      });
    },
    queryParams: {
      userspecific: {
        refreshModel: true,
        replace: true
      }
    },
    actions: {
      toggleUserSpecific(currentValue){
        const switchedValue = currentValue != "true";
        this.transitionTo({ queryParams: { userspecific: switchedValue }});
      }
    }
  }
);
