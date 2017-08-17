import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service('session'),
  actions: {
    loginAction(){
      this.get('loginAction')();
    },
    startUpdateLocationAction(){
      this.get('startUpdateLocationAction')();
    }
  }
});
