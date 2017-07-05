import Ember from 'ember';
import chroma from 'chroma';


export default Ember.Controller.extend({
  lat: 51.3,
  lng: 10,
  zoom: 6,
  tileLayerUrl: 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
  scale: chroma.scale(['yellow', 'red', 'black']),

  actions: {
    style(feature) {
      return {
        fillColor: this.get('scale')(feature.properties.user_count_fraction).hex(),
        weight: 2,
        opacity: 1,
        color: 'white',
        dashArray: '3',
        fillOpacity: 0.7
      }
    }
  }
});
