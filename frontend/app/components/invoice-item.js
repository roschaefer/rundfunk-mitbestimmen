import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service('session'),
  tagName: 'tr',
  classNames: 'invoice-item',
  actions: {
    remove(){
      this.get('removeAction')(this.get('impression'));
    },
    update(amount){
      this.get('updateAction')(this.get('impression'), amount);
    },
    toggleFixed(){
      let impression = this.get('impression');
      if (impression.get('fixed')) {
        this.get('unfixAction')(this.get('impression'));
      } else{
        this.get('fixAction')(this.get('impression'));
      }
    },
  }

});
