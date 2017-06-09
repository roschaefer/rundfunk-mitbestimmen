import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  store: Ember.inject.service(),
  size: 9,
  step: 0,

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
    back(){
      this.decrementProperty('step');
      this.get('browse')(this.get('step'));
    },
    next(){
      this.incrementProperty('step');
      this.get('browse')(this.get('step'));
    },
  }
});
