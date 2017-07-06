import Ember from 'ember';

export default Ember.Component.extend({
  displayedState: Ember.computed('state', function() {
    return this.get('state') || 'Germany';
  }),
  displayedNumber: Ember.computed('count', function() {
    return this.get('count') || this.get('totalGermanUsers');
  }),
  displayedPercentage: Ember.computed('count', function() {
    if (this.get('count')) {
      return `${((this.get('count')/this.get('totalGermanUsers')) * 100).toFixed(2)}`;
    } else {
      return `${((this.get('totalGermanUsers')/this.get('totalUsers')) * 100).toFixed(2)}`;
    }
  }),
  displayedPercentageTranslation: Ember.computed('count', function() {
    if (Ember.isNone(this.get('count'))){
        return 'visualize.geo.info-box.of-the-world';
    } else {
        return 'visualize.geo.info-box.of-germany';
    }
  })
});
