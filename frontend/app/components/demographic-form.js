import Component from '@ember/component';
import { isNone } from '@ember/utils';

export default Component.extend({
  tagName: '',
  init() {
    this._super(...arguments);
    this.set('genders', ['male', 'female', 'other']);
    this.set('approxBirthYears',[
      '0-4', '5-9', '10-14', '15-19',
      '20-24', '25-29', '30-34', '35-39', '40-44',
      '45-49', '50-54', '55-59', '60-64', '65-69',
      '70-74', '75-79', '80-84', '85-89', '90-94',
      '95-99', '100 + '])
  },
  actions: {
    update(attribute, value) {
      switch (value) {
        case '0-4':
          value = 2015;
          break;
        case '5-9':
          value = 2010;
          break;
        case '10-14':
          value = 2005;
          break;
        case '15-19':
          value = 2000;
          break;
        case '20-24':
          value = 1995;
          break;
        case '25-29':
          value = 1990;
          break;
        case '30-34':
          value = 1985;
          break;
        case '35-39':
          value = 1980;
          break;
        case '40-44':
          value = 1975;
          break;
        case '45-49':
          value = 1970;
          break;
        case '50-54':
          value = 1965;
          break;
        case '55-59':
          value = 1960;
          break;
        case '60-64':
          value = 1955;
          break;
        case '65-69':
          value = 1950;
          break;
        case '70-74':
          value = 1945;
          break;
        case '75-79':
          value = 1940;
          break;
        case '80-84':
          value = 1935;
          break;
        case '85-90':
          value = 1930;
          break;
        case '91-94':
          value = 1925;
          break;
        case '95-99':
          value = 1920;
          break;
        case '100 + ':
          value = 1915;
          break;
      }
      let user = this.get('user');
      if (!isNone(user)){
        user.set(attribute, value);
        user.save();
      }
    }
  }
  });
