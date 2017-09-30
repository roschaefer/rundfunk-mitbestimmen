import DS from 'ember-data';

export default DS.Model.extend({
  budget: 17.5,
  impressions: DS.hasMany('impression'),


  // SOURCE: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Math/floor
  floor10(value, exp) {
    // If the exp is undefined or zero...
    if (typeof exp === 'undefined' || +exp === 0) {
      return Math.floor(value);
    }
    value = +value;
    exp = +exp;
    // If the value is not a number or the exp is not an integer...
    if (isNaN(value) || !(typeof exp === 'number' && exp % 1 === 0)) {
      return NaN;
    }
    // Shift
    value = value.toString().split('e');
    value = Math.floor(+(value[0] + 'e' + (value[1] ? (+value[1] - exp) : -exp)));
    // Shift back
    value = value.toString().split('e');
    return +(value[0] + 'e' + (value[1] ? (+value[1] + exp) : exp));
  },
  twoDecimalDifference(desired, current){
    let diff = (desired - current).toFixed(2);
    return diff;
  },
  distributeEvenly(impressions, share){
    let count = impressions.length;
    let newAmount = Math.max(share/count, 0);
    newAmount = this.floor10(newAmount, -2);
    impressions.setEach('amount', newAmount);
  },
  freeBudget(){
    return this.budget - this.fixedBudget();
  },
  unfixedImpressions(){
    let impressions = this.get('impressions');
    return impressions.filter((s) => {
      return ! s.get('fixed');
    });
  },
  fixedImpressions(){
    let impressions = this.get('impressions');
    return impressions.filter((s) => {
      return s.get('fixed');
    });
  },
  fixedBudget(){
    return this.budgetOf(this.fixedImpressions());
  },
  redistribute() {
    this.distributeEvenly(this.unfixedImpressions(), this.freeBudget());
  },
  budgetOf(impressions){
    return impressions.reduce((sum, s) => {
      return sum + (s.get('amount') || 0.0);
    }, 0.0);
  },
  total(){
    return this.budgetOf(this.get('impressions'));
  },
  leftOver(){
    return this.budget - this.total();
  },
  allocate(impression, desiredAmount){
    // truncate desiredAmount to 2 decimals
    desiredAmount = Math.floor(desiredAmount * 100) / 100;
    // amount for impression before change
    let currentAmount = impression.get('amount') || 0;
    // all impressions for which amount can be changed
    let pool = this.unfixedImpressions().filter((s) => {
      return impression !== s;
    });
    // all amounts allocated on impressions that can be used
    // + the eventual not used amount
    let poolBudget = this.budgetOf(pool) + this.leftOver();
    // the maximum possible amount increment will be returned
    // if poolBudget is smaller than the desired increment, then only
    //. an increment of "poolBudget" will be done
    let desiredDiff = this.twoDecimalDifference(desiredAmount,currentAmount);
    let diff = Math.min(poolBudget, this.floor10(desiredDiff, -2));
    // if the increment does not use all the budget, then distribute 
    // the remaining budget between the free impressions
    let remainingBudget = this.twoDecimalDifference(poolBudget, diff);
    this.distributeEvenly(pool, remainingBudget);

    let newAmount = currentAmount + diff;
    return newAmount;
  },
  remove(impression) {
    let impressions = this.get('impressions');
    impressions.removeObject(impression);
    this.redistribute();
  },
  initializeAmounts(){
    this.redistribute();
  },
  reduceFirstImpressions(){
    return this.unfixedImpressions().filter((s) => {
      return s.get('amount') !== null;
    });
  },
});
