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
    let currentAmount = impression.get('amount') || 0;
    let pool = this.unfixedImpressions().filter((s) => {
      return impression !== s;
    });
    let poolBudget = this.budgetOf(pool) + this.leftOver();
    let diff = Math.min(poolBudget, this.floor10(desiredAmount - currentAmount, -2));
    this.distributeEvenly(pool, poolBudget - diff);
    return currentAmount + diff;
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
