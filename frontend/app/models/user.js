import DS from 'ember-data';
import { computed } from '@ember/object';
import moment from 'moment';
import { isPresent } from '@ember/utils';
import { inject as service } from '@ember/service';
import { alias } from '@ember/object/computed';

export default DS.Model.extend({
  locale: DS.attr('string'),
  email: DS.attr('string'),
  gender: DS.attr('string'),
  birthday: DS.attr('date'),
  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  countryCode: DS.attr('string'),
  state: DS.attr('string'),
  city: DS.attr('string'),
  postalCode: DS.attr('string'),

  demography: service(),
  ageGroups: alias('demography.ageGroups'),
  ageGroupLabels: alias('demography.ageGroupLabels'),

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
        return ((from <= years) && ((to === null) || (years <= to)));
      });
      if (ageGroup[1] === null) return '100+';
      return ageGroup.join('-');
    },
    set(key, ageGroup){
      if(!isPresent(ageGroup)) return undefined;
      let years;
      if (ageGroup.match(/\d+-\d+/)) {
        const [from, to] = ageGroup.split('-');
        years = parseInt(from) + ((parseInt(to) - parseInt(from))/2.0);
      } else if (ageGroup === '100+') {
        years = 100
      } else {
        return undefined;
      }
      let birthday = moment();
      birthday = birthday.subtract(years, 'years');
      birthday = birthday.startOf('day');
      birthday = birthday.toDate();
      this.setProperties({birthday});
      return ageGroup;
    }
  }),
  hasLocation: computed('latitude', 'longitude', function() {
    return (this.get('latitude') && this.get('longitude') && true);
  }),
});
