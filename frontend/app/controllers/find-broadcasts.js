import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  intl: Ember.inject.service(),
  queryParams: ['sort', 'q', 'medium', 'station'],
  sort: 'random',
  q: null,
  medium: null,
  station: null,

  page: Ember.computed.alias("content.broadcasts.page"),
  perPage: Ember.computed.alias("content.broadcasts.perPage"),
  totalPages: Ember.computed.alias("content.broadcasts.totalPages"),

  positiveSelectionsWithoutAmount: Ember.computed.filterBy('model.selections','needsAmount', true),

  actions: {
    searchAction(query){
      this.send('setQuery', query);
    },
    browse(step){
      if(this.store.peekAll('selection').isAny('isLoading', true)){
        return; // avoid willCommit in root.loading state error
      }
      this.get('model.broadcasts').map((broadcast) => {
        let selection = broadcast.setDefaultResponse('neutral');
        selection.save();
      });
      this.set('page', step);
    },
    respond(broadcast){
      broadcast.get('selections.firstObject').save();
    },
  }
});

