import Ember from 'ember';

export default Ember.Component.extend({
  intl: Ember.inject.service(),
  tagName: '',
  actions: {
    changed(){
      let groupValue = this.get('groupValue');
      this.sendAction('action', groupValue);
    },
  }
});
