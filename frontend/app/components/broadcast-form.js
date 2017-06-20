import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service('session'),
  classNames: 'ui form broadcast-form',
  elementId: 'broadcast-form',
  classNameBindings: [
    'broadcast.isValid::error',
    'broadcast.isSaving:loading',
    'broadcast.success:success',
  ],
  tagName: 'form',
  displayedStations: Ember.computed('broadcast.medium', function() {
    let filteredStations = this.get('stations');
    if (this.get('broadcast')){
      filteredStations = filteredStations.filter((s) => {
        return s.get('medium').get('id') === this.get('broadcast').get('medium').get('id');
      });
    }
    return filteredStations;
  }),
  sortedStations: Ember.computed.sort('displayedStations', 'sortDefinition'),
  sortDefinition: [ 'name:asc' ],

  submit(event) {
    event.preventDefault();
    this.get('broadcast').saveAndSetSuccess();
  },
  actions: {
    selectMedium(mediumId){
      let medium = this.get('media').findBy("id", mediumId);
      this.get("broadcast").set("medium", medium);
      this.get("broadcast").set("station", null); //clear station
    },
    selectStation(stationId){
      let station = this.get('stations').findBy("id", stationId);
      this.get("broadcast").set("station", station);
    },
    newBroadcast(){
      this.sendAction('newBroadcast');
    },
  }
});
