import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['item'],
  didReceiveAttrs(){
    let selection = this.get('broadcast').get('selections').objectAt(0);
    if (selection) {
      this.set('response', selection.get('response'));
    }
  }
});
