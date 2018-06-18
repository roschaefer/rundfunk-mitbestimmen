import Service from '@ember/service';

export default Service.extend({
  genders: null,
  ageGroups: null,

  init() {
    this._super(...arguments);
    this.set('genders', ['male', 'female', 'other']);
    this.set('ageGroups', ['0-4', '5-9', '10-14', '15-19',
      '20-24', '25-29', '30-34', '35-39', '40-44',
      '45-49', '50-54', '55-59', '60-64', '65-69',
      '70-74', '75-79', '80-84', '85-89', '90-94',
      '95-99', '100+']);
  }
});
