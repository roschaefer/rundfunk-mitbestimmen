import Controller from '@ember/controller';
import { inject as service } from '@ember/service';

export default Controller.extend({
  intl: service(),
  actions: {
    back(){
      history.back();
    },
    loginAction(){
      this.transitionToRoute('login');
    },
    editAction(broadcast){
      this.transitionToRoute('broadcast.edit', broadcast);
    },
    respond(broadcast){
      broadcast.get('impressions.firstObject').save();
    }
  }
});
