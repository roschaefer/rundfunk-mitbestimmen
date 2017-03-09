import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['decision-card ui raised centered fluid card transition hidden fully-displayed'],
  classNameBindings: [
    'responsePositive:green',
  ],

  didReceiveAttrs(){
    let selection = this.get('broadcast').get('selections').objectAt(0);
    if (selection) {
      this.set('responsePositive', (selection.get('response') === 'positive'));
      this.set('responseNeutral', (selection.get('response') === 'neutral'));
    } else {
      this.set('responsePositive', false);
      this.set('responseNeutral', false);
    }
  },
  didRender(){
    this.$().transition('fade in', 200);
  },
  actions: {
    back(){
      let back = this.get('back');
      back();
    },
    decideAndNext(response) {
      let broadcast = this.get('broadcast');
      let decide = this.get('decide');
      let next = this.get('next');
      this.$().transition('slide up out', 200);
      Ember.run.later(() => {
        decide(broadcast, response);
        next();
      }, 180);
    }
  }
});
