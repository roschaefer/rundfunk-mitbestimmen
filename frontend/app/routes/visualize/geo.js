import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';

export default Ember.Route.extend(ResetScrollPositionMixin, {
  model() {
    return RSVP.hash({
      markers: this.store.findAll('chart-data/geo/marker'),
      geojson: Ember.$.get('http://localhost:3000/chart_data/geo/geojson')
    });
  }
});
