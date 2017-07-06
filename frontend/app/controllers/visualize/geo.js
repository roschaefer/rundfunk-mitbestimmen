import Ember from 'ember';
import chroma from 'chroma';


export default Ember.Controller.extend({
  lat: 51.3,
  lng: 10,
  zoom: 6,
  tileLayerUrl: 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
  feature: null,
  germanUserCount: Ember.computed('model.geojson', function() {
    return this.get('model.geojson.features').reduce((sum, feature) =>{
      return sum + feature.properties.user_count_total;
    }, 0);
  }),
  germanUserFraction: Ember.computed('germanUserCount', 'summarizedStatistic', function() {
    return this.get('germanUserCount')/this.get('model.summarizedStatistic.registeredUsers');
  }),
  scale: chroma.scale('OrRd').classes([0, 0.005, 0.01, 0.02, 0.03, 0.05, 0.10, 0.15, 0.2, 0.3, 0.5, 0.7]),
  displayedProperties: Ember.computed('feature', function() {
    const feature = this.get('feature');
    if (feature){
      return {
        name: feature.properties.NAME_1,
        user_count_total: feature.properties.user_count_total,
        user_count_percentage: `${(feature.properties.user_count_fraction * 100).toFixed(2)}%`
      }
    } else {
      return {
        name: 'Germany',
        user_count_total: this.get('germanUserCount'),
        user_count_percentage: `${(this.get('germanUserFraction') * 100).toFixed(2)}%`
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
