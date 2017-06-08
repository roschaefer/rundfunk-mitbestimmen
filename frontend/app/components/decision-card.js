import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['decision-card ui fluid card'],

  actions: {
    respond(response){
      this.get('broadcast').respond(response);
      if (this.get('respondAction')) {
        this.get('respondAction')(this.get('broadcast'));
      }
      this.rerender();
    }
  }
});
