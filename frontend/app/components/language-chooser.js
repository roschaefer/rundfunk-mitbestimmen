import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  intl: Ember.inject.service(),
  store: Ember.inject.service(),
  session: Ember.inject.service(),
  actions: {
    choose(lang){
      let intl = this.get('intl');
      intl.setLocale(lang);
      if(this.get('session.isAuthenticated')){
        this.get('store').queryRecord('user', {}).then((user) => {
          user.set('locale', lang);
          user.save();
        });
      }
    }
  }
});
