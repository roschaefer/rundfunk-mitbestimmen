import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  session: service(),
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
