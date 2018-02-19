import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  session: service('session'),
  actions: {
    loginAction(){
      this.get('loginAction')();
    },
    startUpdateLocationAction(){
      this.get('startUpdateLocationAction')();
    }
  }
});
