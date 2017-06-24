import Ember from 'ember';

export default Ember.Component.extend({
  didReceiveAttrs() {
    this._super(...arguments);
    this.set('currentAmount', this.get('amount'));
  },
  sanitizeAmount(amount){
    let sanitized = amount.replace(/,/g,'.'); // for localization
    sanitized = sanitized.replace(/[^0-9.]+/g,'');
    return parseFloat(sanitized);
  },
  actions: {
    changeAmount(amount){
      let changeAmountAction = this.get('changeAmountAction');
      let sanitizedAmount = this.sanitizeAmount(amount)
      changeAmountAction(sanitizedAmount);
      this.rerender();
    },
    rollback(){
      this.set('currentAmount', this.get('amount'));
      this.rerender();
    }
  }
});
