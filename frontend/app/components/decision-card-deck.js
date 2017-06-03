import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  tagName: '',
  size: 9,
  step: 0,

  positiveReviews: Ember.computed('step', 'broadcasts', function() {
    return this.get('store').peekAll('selection').filter((s) => {
      return (s.get('response') === 'positive') && (!s.get('amount'));
    }).get('length');
  }),
  backButtonCss: Ember.computed('step', function() {
    if (this.get('step') > 0){
      return '';
    } else{
      return 'disabled';
    }
  }),
  nextButtonCss: Ember.computed('size', 'broadcasts', function() {
    if (this.get('broadcasts.length') < this.get('size')){
      return 'disabled';
    } else{
      return '';
    }
  }),

  actions: {
    decide(broadcast, response) {
      let updateAction = this.get('update');
      updateAction(broadcast, response);
    },
    back(){
      this.decrementProperty('step');
      this.get('browse')(this.get('step'));
    },
    next(){
      this.incrementProperty('step');
      this.get('browse')(this.get('step'));
    },
    loadMore(){
      this.sendAction("loadMore");
    },
  }
});
