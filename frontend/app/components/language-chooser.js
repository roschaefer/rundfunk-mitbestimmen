import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  tagName: '',
  intl: service(),
  store: service(),
  session: service(),
  actions: {
    choose(lang){
      let intl = this.get('intl');
      intl.setLocale(lang);
      this.get('session').set('data.locale', lang)
      if(this.get('session.isAuthenticated')){
        this.get('store').queryRecord('user', {}).then((user) => {
          user.set('locale', lang);
          user.save();
        });
      }
    }
  }
});
