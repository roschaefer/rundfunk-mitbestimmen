import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service('session'),
  actions: {
    close(){
      this.get('close')();
    },
    edit(){
      this.get('editAction')(this.get('broadcast'));
    },
    login(){
      this.get('loginAction')();
    },
    respond(response){
      this.get('broadcast').respond(response);
      if (this.get('respond')) {
        this.get('respond')(this.get('broadcast'));
      }
    }
  }
});
