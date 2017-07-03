import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  actions: {
    submitSort(direction) {
      this.set('sort', direction);
      this.get('sortBroadcasts')(direction);
    }
  }
});
