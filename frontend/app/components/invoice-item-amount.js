import Ember from 'ember';

export default Ember.Component.extend({
  didReceiveAttrs() {
    this._super(...arguments);
    this.set('currentAmount', this.get('amount'));
  },
  actions: {
    changeAmount(amount){
      let changeAmountAction = this.get('changeAmountAction');
      let sanitizedAmount = amount.replace(/,/g,'.'); // for localization
      sanitizedAmount = parseFloat(sanitizedAmount.replace(/[^0-9\.]/g,''));
      changeAmountAction(sanitizedAmount);
      this.rerender();
    },
    rollback(){
      this.set('currentAmount', this.get('amount'));
      this.rerender();
    }
  }
});
