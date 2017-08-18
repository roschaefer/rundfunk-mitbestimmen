import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';

export default Ember.Route.extend(ResetScrollPositionMixin, {
  session: Ember.inject.service('session'),
  model() {
    const host = this.store.adapterFor('summarized-statistic').get('host');
    let model = {
      geojson: Ember.$.get(`${host}/chart_data/geo/geojson`),
      summarizedStatistic: this.store.queryRecord('summarized-statistic', {})
    };
    if (this.get('session.isAuthenticated')) {
      model.user = this.store.queryRecord('user', {});
    }
    return RSVP.hash(model);
  }
});
