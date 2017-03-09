import Ember from 'ember';

export default Ember.Component.extend({
  classNames: "menu",
  intl: Ember.inject.service(),
  actions: {
    choose(lang){
      let intl = this.get('intl');
      intl.setLocale(lang);
    }
  }
});
