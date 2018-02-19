import Component from '@ember/component';

export default Component.extend({
  classNames: ['help-message transition hidden'],
  didRender(){
    this.$().transition('scale in', 1000);
  }
});
