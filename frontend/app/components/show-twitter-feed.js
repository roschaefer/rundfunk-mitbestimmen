import Component from '@ember/component';

export default Component.extend({
  tag: 'div',
  classNames: ['ui one column grid'],
  showFeed: false,
  actions: {
    showTwitterFeed() {
      this.set('showFeed', true);
    }
  }
});
