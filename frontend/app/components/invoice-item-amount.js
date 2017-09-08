import Ember from 'ember';

export default Ember.Component.extend({
  didReceiveAttrs() {
    this._super(...arguments);
    this.set('currentAmount', this.get('amount'));
  }
});
