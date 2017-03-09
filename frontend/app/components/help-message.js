import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['help-message transition hidden'],
  didRender(){
    this.$().transition('scale in', 1000);
  }
});
