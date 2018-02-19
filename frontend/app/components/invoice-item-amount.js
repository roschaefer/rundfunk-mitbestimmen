import Component from '@ember/component';

export default Component.extend({
  didReceiveAttrs() {
    this._super(...arguments);
    this.set('currentAmount', this.get('amount'));
  }
});
