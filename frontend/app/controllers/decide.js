import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  intl: Ember.inject.service(),
  queryParams: ['q', 'medium', 'station'],
  q: null,
  medium: null,
  station: null,

  page: Ember.computed.alias("content.broadcasts.page"),
  perPage: Ember.computed.alias("content.broadcasts.perPage"),
  totalPages: Ember.computed.alias("content.broadcasts.totalPages"),

  positiveSelectionsWithoutAmount:  Ember.computed.filter('model.selections.@each.needsAmount', (s) => {
    return s.get('needsAmount');
  }),

  actions: {
    searchAction(query){
      this.send('setQuery', query);
    },
    respond(broadcast){
      broadcast.get('selections.firstObject').save();
    },
    browse(step){
      this.get('model.broadcasts').forEach((broadcast) => {
        let selection = broadcast.setDefaultResponse('neutral');
        selection.save();
      });
      this.set('page', step);
    },
  }
});

