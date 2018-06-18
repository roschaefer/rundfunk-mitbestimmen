import Component from '@ember/component';
import { isNone } from '@ember/utils';
import { inject as service } from '@ember/service';

export default Component.extend({
  tagName: '',
  demography: service(),
  init() {
    this._super(...arguments);
    this.set('genders', this.get('demography').get('genders'));
    this.set('ageGroups', this.get('demography').get('ageGroups'));
  },

  actions: {
    update(attribute, value) {
      let user = this.get('user');
      if (!isNone(user)){
        user.set(attribute, value);
        user.save();
      }
    }
  }
  });
