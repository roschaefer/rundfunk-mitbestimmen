import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  email: DS.attr('string'),
  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  countryCode: DS.attr('string'),
  stateCode: DS.attr('string'),
  city: DS.attr('string'),
  postalCode: DS.attr('string'),
  coordinates: Ember.computed('latitude', 'longitude', {
    get(){
      return [this.get('latitude'), this.get('longitude')];
    },
    set(key, coordinates){
      let [latitude, longitude ] = coordinates;
      this.setProperties({latitude, longitude});
      return coordinates;
    }
  }),
  hasLocation: Ember.computed('latitude', 'longitude', function() {
    return (this.get('latitude') && this.get('longitude') && true);
  }),
});
