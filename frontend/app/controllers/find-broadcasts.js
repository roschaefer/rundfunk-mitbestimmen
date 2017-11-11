import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  intl: Ember.inject.service(),
  queryParams: ['page', 'perPage', 'sort', 'q', 'medium', 'station'],
  sort: 'random',
  q: null,
  medium: null,
  station: null,

  page: 1,
  perPage: 6,
  totalPages: Ember.computed.alias("content.broadcasts.totalPages"),

  positiveImpressionsWithoutAmount: Ember.computed.filterBy('model.impressions','needsAmount', true),

  actions: {
    searchAction(query){
      this.send('setQuery', query);
      this.set('page', 1);
    },
    browse(step){
      this.set('page', step);
    },
    respond(broadcast){
      broadcast.get('impressions.firstObject').save();
    },
    login(){
      console.log("I am here!")
    },
    sortBroadcasts(direction) {
      this.set('sort', direction);
      this.get('filterParams').sort = direction;
    },
  }
});

