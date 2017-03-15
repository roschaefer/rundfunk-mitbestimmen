import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service('session'),
  tagName: '',
  primaryReloadButton:Ember.computed('positiveReviews', function() {
    return (this.get('positiveReviews') > 1 ? '' :'primary');
  }),
  primaryInvoiceButton:Ember.computed('positiveReviews', function() {
    return (this.get('positiveReviews') > 1 ? 'primary' :'');
  }),
  actions: {
    loadMore(){
      this.get("loadMore")();
    }
  }
});
