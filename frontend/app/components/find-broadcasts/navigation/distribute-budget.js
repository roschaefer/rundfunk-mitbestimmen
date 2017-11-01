import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',

  distibuteButtonCss: Ember.computed('recentPositives', function() {
    switch(this.get('recentPositives')) {
      case 0: return ' disabled ';
      case 1: return ' ';
      case 2: return ' ';
      default: return ' primary ';
    }
  }),
});
