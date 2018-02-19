import DS from 'ember-data';
import { computed } from '@ember/object';

export default DS.Model.extend({
  locale: DS.attr('string'),
  email: DS.attr('string'),
  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  countryCode: DS.attr('string'),
  stateCode: DS.attr('string'),
  city: DS.attr('string'),
  postalCode: DS.attr('string'),
  coordinates: computed('latitude', 'longitude', {
    get(){
      return [this.get('latitude'), this.get('longitude')];
    },
    set(key, coordinates){
      let [latitude, longitude ] = coordinates;
      this.setProperties({latitude, longitude});
      return coordinates;
    }
  }),
  hasLocation: computed('latitude', 'longitude', function() {
    return (this.get('latitude') && this.get('longitude') && true);
  }),
});
