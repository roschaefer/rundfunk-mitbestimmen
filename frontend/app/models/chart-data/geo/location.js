import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  countryCode: DS.attr('string'),
  stateCode: DS.attr('string'),
  city: DS.attr('string'),
  postalCode: DS.attr('string'),
  coordinates: Ember.computed('latitude', 'longitude', function() {
    return [this.get('latitude'), this.get('longitude')];
  }),
});
