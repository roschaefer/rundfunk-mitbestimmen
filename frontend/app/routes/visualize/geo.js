import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';

export default Ember.Route.extend(ResetScrollPositionMixin, {
  model() {
    const host = this.store.adapterFor('chart-data/geo/location').get('host');
    return RSVP.hash({
      locations: this.store.findAll('chart-data/geo/location'),
      geojson: Ember.$.get(`${host}/chart_data/geo/geojson`)
    });
  }
});
