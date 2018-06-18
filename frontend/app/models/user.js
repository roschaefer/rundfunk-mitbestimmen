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
      const birthday = this.get('birthday');
      if (!isPresent(birthday)) return undefined; 
      let years = moment().diff(birthday, 'years');
      let ageGroup = this.get('ageGroups').find((ageGroup) => {
        let [from, to] = ageGroup;
        return ((from <= years) && ((to === null) || (years < to)));
      });
      if (ageGroup[1] === null) return '100+';
      return ageGroup.join('-');
    },
    set(key, ageGroup){
      if(isPresent(ageGroup)) {
        let from, to;
        if (ageGroup.match(/\d+-\d+/)) {
          [from, to] = ageGroup.split('-');
        } else if (ageGroup === '100+') {
          from, to = 100, null
        } else {
          return undefined;
        }
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
    let ageGroups = Array.from({length: 20}, (v, i) => {
        return [i*5, (i*5)+4];
      });
      ageGroups.push([100, null]);
    this.set('ageGroups', ageGroups);
  },
});
