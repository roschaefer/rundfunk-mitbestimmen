import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['decision-card ui fluid card'],
  response: 'neutral',

  didReceiveAttrs() {
    this._super(...arguments);
    this.set('response', this.get('broadcast.response'));
  },
  actions: {
    respond(response){
      this.set('response', response);
      this.rerender();
    },
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
