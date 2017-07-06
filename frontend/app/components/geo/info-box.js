import Ember from 'ember';

export default Ember.Component.extend({
  displayedState: Ember.computed('properties', function() {
    return this.get('properties.state') || 'Germany';
  }),
  displayedNumber: Ember.computed('properties', function() {
    const properties = this.get('properties');
    if (properties.count) {
      return properties.count;
    } else {
      return properties.totalGermanUsers;
    }
  }),
  displayedPercentage: Ember.computed('properties', function() {
    const properties = this.get('properties');
    if (properties.count) {
      return `${((properties.count/properties.totalGermanUsers) * 100).toFixed(2)}`;
    } else {
      return `${((properties.totalGermanUsers/properties.totalUsers) * 100).toFixed(2)}`;
    }
  }),
});
