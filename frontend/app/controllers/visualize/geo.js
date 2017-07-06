import Ember from 'ember';
import chroma from 'chroma';


export default Ember.Controller.extend({
  lat: 51.3,
  lng: 10,
  zoom: 6,
  tileLayerUrl: 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
  scale: chroma.scale('OrRd').classes([0, 0.005, 0.01, 0.02, 0.03, 0.05, 0.10, 0.15, 0.2, 0.3, 0.5, 0.7]),
  feature: null,
  totalGermanUsers: Ember.computed('model.geojson', function() {
    return this.get('model.geojson.features').reduce((sum, feature) =>{
      return sum + feature.properties.user_count_total;
    }, 0);
  }),
  displayedProperties: Ember.computed('feature', function() {
    const feature = this.get('feature');
    if (feature){
      return {
        count: feature.properties.user_count_total,
        state: feature.properties.NAME_1,
        totalGermanUsers: this.get('totalGermanUsers'),
        totalUsers: this.get('model.summarizedStatistic.registeredUsers')
      }
    } else {
      return {
        totalGermanUsers: this.get('totalGermanUsers'),
        totalUsers: this.get('model.summarizedStatistic.registeredUsers')
      }
    }
  }),

  actions: {
    style(feature) {
      return {
        fillColor: this.get('scale')(feature.properties.user_count_fraction).hex(),
        weight: 2,
        opacity: 1,
        color: 'white',
        dashArray: '5',
        fillOpacity: 0.7
      }
    },
    onEachFeature(feature, layer) {
      layer.on({
        mouseover: (e) => {
          let layer = e.target;
          layer.setStyle({
            dashArray: '',
            weight: 5,
            color: '#AAA',
          });
          layer.bringToFront();
          this.set('feature', feature);
        },
        mouseout: (e) => {
          let layer = e.target;
          layer.setStyle({
            weight: 2,
            dashArray: '5',
            color: 'white',
          });
          this.set('feature', null);
        },
      });
    },
  }
});
