import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  value: '',
  tagName: '',
  didReceiveAttrs(){
    this.set('step', 0);
  },
  positiveReviews: Ember.computed('step', 'broadcasts', function() {
    return this.get('store').peekAll('selection').filter((s) => {
      return (s.get('response') === 'positive') && (!s.get('amount'));
    }).get('length');
  }),
  primaryReloadButton:Ember.computed('positiveReviews', function() {
    return (this.get('positiveReviews') > 1 ? '' :'primary');
  }),
  primaryInvoiceButton:Ember.computed('positiveReviews', function() {
    return (this.get('positiveReviews') > 1 ? 'primary' :'');
  }),
  currentBroadcast: Ember.computed('step', 'broadcasts', function() {
    let broadcasts = this.get('broadcasts');
    let step = this.get('step');
    return broadcasts.objectAt(step);
  }),

  actions: {
    decide(broadcast, response) {
      let updateAction = this.get('update');
      updateAction(broadcast, response);
    },
    back(){
      this.decrementProperty('step');
    },
    next(){
      this.incrementProperty('step');
    },
    loadMore(){
      this.sendAction("loadMore");
    }
  }
});
