import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service('session'),
  tagName: 'tr',
  classNames: 'invoice-item',
  actions: {
    remove(){
      this.get('removeAction')(this.get('selection'));
    },
    update(amount){
      this.get('updateAction')(this.get('selection'), amount);
    },
    toggleFixed(){
      let selection = this.get('selection');
      if (selection.get('fixed')) {
        this.get('unfixAction')(this.get('selection'));
      } else{
        this.get('fixAction')(this.get('selection'));
      }
    },
    showModal(){
      this.get('showModal')();
    }

  }

});
