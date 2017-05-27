//app/controllers/application.js
import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  intl: Ember.inject.service(),
  queryParams: ['q', 'medium', 'station'],
  q: null,
  medium: null,
  station: null,

  actions: {
    createOrUpdateSelection(broadcast, response){
      let selection = broadcast.respond(response);
      return selection.save();
    },
    searchAction(query){
      this.send('setQuery', query);
    }
  }
});

