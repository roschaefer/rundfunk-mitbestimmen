import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  intl: service(),
  tagName: '',
  totalCount: computed('broadcasts', function() {
    return this.get('broadcasts.meta.total-count');
  }),
  displayedStations: computed('filterParams', 'stations', function() {
    return this.get('stations').filter((s) => {
      return s.get('medium').get('id') === this.get('filterParams').medium;
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
      this.get('filterParams').medium = mediumId;
      this.get('filterParams').station = null; //clear station
      let searchAction = this.get('searchAction');
      searchAction(this.get('filterParams'));
    },
    filterStation(stationId){
      this.get('filterParams').station = stationId;
      let searchAction = this.get('searchAction');
      searchAction(this.get('filterParams'));
    }
  }
});
