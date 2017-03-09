import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  actions: {
    showModal(){
      Ember.$('.signup-modal').modal('show');
    },
    showLogin(){
      this.send('login');
    }
  }
});
