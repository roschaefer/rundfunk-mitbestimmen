import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  sortBy: 'title',
  reverseSort: false,
  randomSort: false,
  sortedBroadcasts: Ember.computed.sort('broadcasts', 'sortDefinition'),
  sortDefinition: Ember.computed('sort', function() {
    let sortOrder = this.get('reverseSort') ? 'desc' : 'asc';
    if (this.get('randomSort'))
      return [ `${this.get('sortBy')}:random` ];
    else
      return [ `${this.get('sortBy')}:${sortOrder}` ];
  }),
  actions: {
    respond(broadcast){
      broadcast.get('selections.firstObject').save();
    }
  }
});

