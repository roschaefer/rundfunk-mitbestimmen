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

  didReceiveAttrs() {
    this.set('stationIds', this.get('broadcast.stations').mapBy('id'));
  },

  submit(event) {
    event.preventDefault();
    if (this.get('session.isAuthenticated')){
      this.get('broadcast').saveAndSetSuccess();
    } else {
      this.get('loginAction')();
    }
  },
  actions: {
    selectMedium(mediumId){
      let medium = this.get('media').findBy("id", mediumId);
      this.get("broadcast").set("medium", medium);
      this.get("broadcast.stations").clear();
      this.set("stationIds", this.get('broadcast.stations').mapBy('id'));
    },
    selectStation(stationIds){
      let stations = this.get('stations').filter((station) => {
        return stationIds.includes(station.get('id'));
      });
      this.get("broadcast").set('stations', stations);
    },
    newBroadcast(){
      this.sendAction('newBroadcast');
    },
  }
});
