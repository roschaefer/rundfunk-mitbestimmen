//app/controllers/application.js
import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  queryParams: ['q', 'medium', 'station'],
  q: null,
  medium: null,
  station: null,

  actions: {
    createOrUpdateSelection(broadcast, response){
      let selection = broadcast.respond(response);
      if (this.get('session').get('isAuthenticated')){
        return selection.save();
      } else {
        return selection;
      }
    },
    searchAction(query){
      this.send('setQuery', query);
    }
  }
});

