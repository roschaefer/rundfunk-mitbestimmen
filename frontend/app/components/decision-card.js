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
      this.get('broadcast').respond(response);
      this.set('response', this.get('broadcast.response'));
      this.rerender();
    }
  }
});
