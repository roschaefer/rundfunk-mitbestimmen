import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    close(){
      this.get('close')();
    },
    respond(response){
      this.get('broadcast').respond(response);
      if (this.get('respond')) {
        this.get('respond')(this.get('broadcast'));
      }
    }
  }
});
