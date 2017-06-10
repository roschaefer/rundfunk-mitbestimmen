import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['find-broadcasts-navigation'],

  canStepForward: Ember.computed("step", "totalSteps", function() {
    const step = Number(this.get("step"));
    const totalSteps = Number(this.get("totalSteps"));
    return step <= totalSteps;
  }),

  canStepBackward: Ember.computed("step", function() {
    const step = Number(this.get("step"));
    return step > 1;
  }),

  distibuteButtonCss: Ember.computed('recentPositives', function() {
    const recentPositives = this.get('recentPositives');
    switch(recentPositives) {
      case 0: return ' disabled ';
      case 1: return ' ';
      case 2: return ' ';
      default: return ' primary ';
    }
  }),

  actions: {
    back(){
      if(!this.get('canStepBackward')) { return false; }
      this.get('browse')(this.get('step') - 1);
    },
    next(){
      if(!this.get('canStepForward')) { return false; }
      this.get('browse')(this.get('step') + 1);
    }
  }
});
