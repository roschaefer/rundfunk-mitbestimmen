//app/controllers/application.js
import Controller from '@ember/controller';
import { inject as service } from '@ember/service';

export default Controller.extend({
  session: service('session'),
  intl: service(),
  queryParams: ['specificToUser'],
  specificToUser: false,
  actions: {
    toggleSpecificToUser(){
      this.toggleProperty('specificToUser');
    }
  }
});
