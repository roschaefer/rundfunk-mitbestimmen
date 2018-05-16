import DS from 'ember-data';
import { computed } from '@ember/object';
import moment from 'moment';
import { isPresent } from '@ember/utils';

export default DS.Model.extend({
  ageGroups: null,
  locale: DS.attr('string'),
  email: DS.attr('string'),
  gender: DS.attr('string'),
  birthday: DS.attr('date'),
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
  ageGroup: computed('birthday', {
    get(){
      let years = moment().diff(this.get('birthday'), 'years');
      let ageGroup = this.get('ageGroups').find((ageGroup) => {
        return ((ageGroup[0] <= years) && (years < ageGroup[1]));
      });
      return ageGroup.join('-');
    },
    set(key, ageGroup){
      if(isPresent(key) && key.match(/\d+-\d+/)) {
        let [from, to] = ageGroup.split('-');
        let years = parseInt(from) + ((parseInt(to) - parseInt(from))/2.0);
        let birthday = moment();
        birthday = birthday.subtract(years, 'years');
        birthday = birthday.startOf('day');
        birthday = birthday.toDate();
        this.setProperties({birthday});
        return birthday;
      } else {
        return undefined
      }
    }
  }),
  hasLocation: computed('latitude', 'longitude', function() {
    return (this.get('latitude') && this.get('longitude') && true);
  }),
  init() {
    this._super(...arguments);
    this.set('ageGroups', Array.from({length: 20}, (v, i) => {
        return [i*5, (i*5)+4];
      }));
  },
});
