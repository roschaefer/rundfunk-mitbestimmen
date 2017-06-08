import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['decision-card ui fluid card'],

  actions: {
    respond(response){
      this.get('broadcast').respond(response);
      this.rerender();
    }
  }
});
