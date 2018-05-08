import Component from '@ember/component';
import { isNone } from '@ember/utils';

export default Component.extend({
  tagName: '',
  init() {
    this._super(...arguments);
    this.set('genders', ['male', 'female', 'other']);
    this.set('ageGroups',[
      '0-4', '5-9', '10-14', '15-19',
      '20-24', '25-29', '30-34', '35-39', '40-44',
      '45-49', '50-54', '55-59', '60-64', '65-69',
      '70-74', '75-79', '80-84', '85-89', '90-94',
      '95-99', '100 + '])
  },
  actions: {
    updateGender(gender) {
      let user = this.get('user');
      if (!isNone(user)){
        user.set('gender', gender);
        user.save();
      }
    },

    updateAgeGroup(ageGroup) {
      let user = this.get('user');
      if (!isNone(user)) {
        user.set('ageGroup', ageGroup);
        user.save();
      }
    }
  }
  });
