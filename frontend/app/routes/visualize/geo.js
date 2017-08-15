import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';

export default Ember.Route.extend(ResetScrollPositionMixin, {
  model() {
    const host = this.store.adapterFor('user').get('host');
    return RSVP.hash({
      user: this.store.findRecord('user', 'me'),
      geojson: Ember.$.get(`${host}/chart_data/geo/geojson`),
      summarizedStatistic: this.store.findRecord('summarized-statistic', 0)
    });
  }
});
