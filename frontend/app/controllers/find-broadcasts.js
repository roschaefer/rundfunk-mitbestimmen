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
    },
    browse(step){
      if(this.store.peekAll('impression').isAny('isLoading', true)){
        return; // avoid willCommit in root.loading state error
      }
      this.get('model.broadcasts').map((broadcast) => {
        let impression = broadcast.setDefaultResponse('neutral');
        impression.save();
      });
      this.set('page', step);
    },
    respond(broadcast){
      broadcast.get('impressions.firstObject').save();
    },
    sortBroadcasts(direction) {
      this.set('sort', direction);
      this.get('filterParams').sort = direction;
    },
  }
});

