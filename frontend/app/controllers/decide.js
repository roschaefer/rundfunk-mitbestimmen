//app/controllers/application.js
import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  intl: Ember.inject.service(),
  queryParams: ['q', 'medium', 'station'],
  q: null,
  medium: null,
  station: null,

  actions: {
    createOrUpdateSelection(broadcast, response){
      let selection = broadcast.respond(response);
      if (this.get('session').get('isAuthenticated')){
        return selection.save();
      } else {
        return selection;
      }
    },
    searchAction(query){
      this.send('setQuery', query);
    },
    signupAndDistributeBudget(){
      const dict = {
          networkOrEmail: {
            headerText: this.get('intl').t('decide.next-step.auth0-lock.networkOrEmail.headerText'),
            smallSocialButtonsHeader: this.get('intl').t('decide.next-step.auth0-lock.networkOrEmail.smallSocialButtonsHeader'),
            separatorText: this.get('intl').t('decide.next-step.auth0-lock.networkOrEmail.separatorText'),
          },
        title: this.get('intl').t('decide.next-step.auth0-lock.title')
      }
      this.send('login', { toRoute: '/invoice' }, dict);
    }
  }
});

