//app/controllers/application.js
import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  intl: Ember.inject.service(),
  queryParams: ['q', 'medium', 'station'],
  q: null,
  medium: null,
  station: null,
  page: 1,
  perPage: 9,

  actions: {
    searchAction(query){
      this.send('setQuery', query);
    },
    browse(step){
      console.log(`browse in decide controller: ${step}`);
    }

  }
});

