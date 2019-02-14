import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  intl: service(),
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
      searchAction({
        medium: this.get('mediumId'),
        station: this.get('stationId')
      });
    },
    filterMedium(mediumId){
      this.set('mediumId', mediumId);
      this.set('stationId', null); //clear station
      this.send('search');
    },
    filterStation(stationId){
      this.set('stationId', stationId);
      this.send('search');
    }
  }
});
