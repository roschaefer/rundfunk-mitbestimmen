import Service from '@ember/service';

export default Service.extend({
  genders: null,
  ageGroups: null,
  ageGroupLabels: null,

  init() {
    this._super(...arguments);
    this.set('genders', ['male', 'female', 'other']);
    let groupRange = Array.from({length: 20}, (v, i) => {
        return [i*5, (i*5)+4];
      });

    let ageGroups = groupRange.slice(0); // copy
    ageGroups.push([100, null]);
    this.set('ageGroups', ageGroups);

    let ageGroupLabels = groupRange.map((group) => group.join('-'));
    ageGroupLabels.push('100+');
    this.set('ageGroupLabels', ageGroupLabels);
  },
});
