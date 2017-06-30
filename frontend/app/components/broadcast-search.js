import Ember from 'ember';

export default Ember.Component.extend({
  intl: Ember.inject.service(),
  tagName: '',
  totalCount: Ember.computed('broadcasts', function() {
    return this.get('broadcasts.meta.total-count');
  }),
  displayedStations: Ember.computed('filterParams', 'stations', function() {
    return this.get('stations').filter((s) => {
      return s.get('medium').get('id') === this.get('filterParams').get('medium');
    });
  }),
  sortedStations: Ember.computed.sort('displayedStations', 'sortDefinition'),
  sortDefinition: [ 'name:asc' ],
  actions: {
    search(){
      let searchAction = this.get('searchAction');
      searchAction(this.get('filterParams'));
    },
    filterMedium(mediumId){
      this.get('filterParams').set('medium', mediumId);
      this.get('filterParams').set('station', null); //clear station
      let searchAction = this.get('searchAction');
      searchAction(this.get('filterParams'));
    },
    filterStation(stationId){
      this.get('filterParams').set('station', stationId);
      let searchAction = this.get('searchAction');
      searchAction(this.get('filterParams'));
    }
  }
});
