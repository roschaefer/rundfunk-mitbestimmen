import Ember from 'ember';

export default Ember.Component.extend({

  canStepForward: Ember.computed("step", "totalSteps", function() {
    const page = Number(this.get("step"));
    const totalSteps = Number(this.get("totalSteps"));
    return page < totalSteps;
  }),

  canStepBackward: Ember.computed("step", function() {
    const page = Number(this.get("step"));
    return page > 1;
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
      const step = Number(this.get('step'));
      if(step <= 1) { return false; }
      this.decrementProperty('step');
      this.get('browse')(this.get('step'));
    },
    next(){
      const step = Number(this.get('step'));
      const totalSteps = Number(this.get('totalSteps'));
      if(step >= totalSteps) { return false; }
      this.incrementProperty('step');
      this.get('browse')(this.get('step'));
    }
  }
});
