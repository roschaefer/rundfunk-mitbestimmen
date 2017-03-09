import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service('session'),
  setFooterAttributes(){
    let invoice= this.get('invoice');
    this.set('totalExpenses', invoice.total());
    this.set('remainingBudget', invoice.leftOver());
  },
  didReceiveAttrs() {
    this._super(...arguments);
    this.setFooterAttributes();
  },
  actions: {
    removeItem(selection) {
      let invoice = this.get('invoice');
      selection.set('amount', null);
      selection.set('response', 'neutral');
      selection.set('fixed', false);
      selection.save().then(() => {
        invoice.remove(selection);
        let selections = invoice.get('selections');
        selections.forEach((s) => {
          s.save();
        });
        this.set('selections', selections);
        this.setFooterAttributes();
      });
    },
    fixItem(selection){
      selection.set('fixed', true);
      selection.save();
    },
    unfixItem(selection){
      selection.set('fixed', false);
      selection.set('amount', 0.0); // free some money
      selection.save().then(() => {
        let invoice = this.get('invoice');
        let selections = invoice.get('selections');
        invoice.redistribute();
        selections.forEach((s) => {
          s.save();
        });
        this.set('selections', selections);
        this.setFooterAttributes();
      });
    },
    updateItem(selection, amount) {
      let invoice = this.get('invoice');

      let newAmount = invoice.allocate(selection, amount);
      let selections = invoice.get('selections');
      if (newAmount > selection.get('amount')) {
        Ember.RSVP.all(selections.map((s) => {
          return s.save();
        })).then(() => {
          selection.set('amount', newAmount);
          selection.set('fixed', true);
          selection.save();
          this.set('selections', selections);
          this.setFooterAttributes();
        });
      } else {
        selection.set('amount', newAmount);
        selection.set('fixed', true);
        selection.save().then(() => {
          selections.forEach((s) => {
            s.save();
          });
          this.set('selections', selections);
          this.setFooterAttributes();
        });
      }
    }
  }
});
