import DS from 'ember-data';

export default DS.Model.extend({
  budget: 17.5,
  selections: DS.hasMany('selection'),


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

  distributeEvenly(selections, share){
    let count = selections.length;
    let newAmount = Math.max(share/count, 0);
    newAmount = this.floor10(newAmount, -2);
    selections.setEach('amount', newAmount);
  },
  freeBudget(){
    return this.budget - this.fixedBudget();
  },
  unfixedSelections(){
    let selections = this.get('selections');
    return selections.filter((s) => {
      return ! s.get('fixed');
    });
  },
  fixedSelections(){
    let selections = this.get('selections');
    return selections.filter((s) => {
      return s.get('fixed');
    });
  },
  fixedBudget(){
    return this.budgetOf(this.fixedSelections());
  },
  redistribute() {
    this.distributeEvenly(this.unfixedSelections(), this.freeBudget());
  },
  budgetOf(selections){
    return selections.reduce((sum, s) => {
      return sum + (s.get('amount') || 0.0);
    }, 0.0);
  },
  total(){
    return this.budgetOf(this.get('selections'));
  },
  leftOver(){
    return this.budget - this.total();
  },
  allocate(selection, desiredAmount){
    let currentAmount = selection.get('amount') || 0;
    let pool = this.unfixedSelections().filter((s) => {
      return selection !== s;
    });
    let poolBudget = this.budgetOf(pool) + this.leftOver();
    let diff = Math.min(poolBudget, this.floor10(desiredAmount - currentAmount, -2));
    this.distributeEvenly(pool, poolBudget - diff);
    return currentAmount + diff;
  },
  remove(selection) {
    let selections = this.get('selections');
    selections.removeObject(selection);
    this.redistribute();
  },
  initializeAmounts(){
    this.redistribute();
  },
  reduceFirstSelections(){
    return this.unfixedSelections().filter((s) => {
      return s.get('amount') !== null;
    });
  },
});
