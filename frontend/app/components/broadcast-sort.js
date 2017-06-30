import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  actions: {
    submitSort(direction) {
      this.sendAction('sortBroadcasts', direction);
    }
  }
});
