import Component from '@ember/component';

export default Component.extend({
  actions: {
    login() {
      this.get('loginAction')();
    }
  }
});
