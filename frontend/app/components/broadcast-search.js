import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  intl: service(),
  filterParams: {},
  tagName: '',
  totalCount: computed('broadcasts', function() {
    return this.get('broadcasts.meta.total-count');
  }),
  displayedStations: computed('stations', function() {
    return this.get('stations').filter((station) => {
      return station.get('medium').get('id') === this.get('medium');
    });
  }),
  sortedStations: computed('displayedStations', function() {
    return this.get('displayedStations').sortBy('name');
  }),
  actions: {
    search(){
      let searchAction = this.get('searchAction');
      searchAction(this.get('filterParams'));
    },
    filterMedium(mediumId){
      this.set('filterParams.medium', mediumId);
      this.set('filterParams.station', null); //clear station
      let searchAction = this.get('searchAction');
      searchAction(this.get('filterParams'));
    },
    filterStation(stationId){
      this.set('filterParams.station', stationId);
      let searchAction = this.get('searchAction');
      searchAction(this.get('filterParams'));
    }
  }
});
