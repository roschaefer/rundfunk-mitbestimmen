import Component from '@ember/component';

export default Component.extend({
  tagName: '',
  actions: {
    submitSort(direction) {
      this.set('sort', direction);
      this.get('sortBroadcasts')(direction);
    }
  }
});
