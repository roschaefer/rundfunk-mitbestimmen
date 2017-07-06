import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';

export default Ember.Route.extend(ResetScrollPositionMixin, {
  model() {
    const host = this.store.adapterFor('chart-data/geo/marker').get('host');
    return RSVP.hash({
      markers: this.store.findAll('chart-data/geo/marker'),
      geojson: Ember.$.get(`${host}/chart_data/geo/geojson`)
    });
  }
});
