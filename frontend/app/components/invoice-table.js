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
    removeItem(impression) {
      let invoice = this.get('invoice');
      impression.set('amount', null);
      impression.set('response', 'neutral');
      impression.set('fixed', false);
      impression.save().then(() => {
        invoice.remove(impression);
        let impressions = invoice.get('impressions');
        impressions.forEach((s) => {
          s.save();
        });
        this.set('impressions', impressions);
        this.setFooterAttributes();
      });
    },
    fixItem(impression){
      impression.set('fixed', true);
      impression.save();
    },
    unfixItem(impression){
      impression.set('fixed', false);
      impression.set('amount', 0.0); // free some money
      impression.save().then(() => {
        let invoice = this.get('invoice');
        let impressions = invoice.get('impressions');
        invoice.redistribute();
        impressions.forEach((s) => {
          s.save();
        });
        this.set('impressions', impressions);
        this.setFooterAttributes();
      });
    },
    updateItem(impression, amount) {
      let invoice = this.get('invoice');

      let newAmount = invoice.allocate(impression, amount);
      let impressions = invoice.get('impressions');
      if (newAmount > impression.get('amount')) {
        Ember.RSVP.all(impressions.map((s) => {
          return s.save();
        })).then(() => {
          impression.set('amount', newAmount);
          impression.set('fixed', true);
          impression.save();
          this.set('impressions', impressions);
          this.setFooterAttributes();
        });
      } else {
        impression.set('amount', newAmount);
        impression.set('fixed', true);
        impression.notifyPropertyChange('amount');
        impression.save().then(() => {
          impressions.forEach((s) => {
            s.save();
          });
          this.set('impressions', impressions);
          this.setFooterAttributes();
        });
      }
    }
  }
});
