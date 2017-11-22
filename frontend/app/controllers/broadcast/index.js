import Ember from 'ember';

export default Ember.Controller.extend({
  intl: Ember.inject.service(),
  actions: {
    back(){
      history.back();
    },
    loginAction(){
      const customDict = {
        networkOrEmail: {
          headerText: this.get('intl').t('find-broadcasts.auth0-lock.networkOrEmail.headerText'),
          smallSocialButtonsHeader: this.get('intl').t('find-broadcasts.auth0-lock.networkOrEmail.smallSocialButtonsHeader'),
          separatorText: this.get('intl').t('auth0-lock.networkOrEmail.separatorText'),
        },
      };
      this.send('login', customDict);
    },
    editAction(broadcast){
      this.transitionToRoute('broadcast.edit', broadcast);
    },
    respond(broadcast){
      broadcast.get('impressions.firstObject').save();
    }
  }
});
