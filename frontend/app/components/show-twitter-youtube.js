import Component from '@ember/component';

export default Component.extend({
  tag: 'div',
  classNames: ['ui column grid'],
  showFeed: false,
  actions: {
    showTwitterYouTube() {
      this.set('showContent', true);
    }
  }
});
