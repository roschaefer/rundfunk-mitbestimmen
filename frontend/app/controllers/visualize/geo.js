import Controller from '@ember/controller';
import { computed } from '@ember/object';
import chroma from 'chroma-js';


export default Controller.extend({
  lat: 51.3,
  lng: 10,
  zoom: 6,
  tileLayerUrl: 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
  scale: chroma.scale('OrRd').classes([0, 0.005, 0.01, 0.02, 0.03, 0.05, 0.10, 0.15, 0.2, 0.3, 0.5, 0.7]),
  count: null,
  state: null,
  totalGermanUsers: computed('model.geojson', function() {
    return this.get('model.geojson.features').reduce((sum, feature) =>{
      return sum + feature.properties.user_count_total;
    }, 0);
  }),
  totalUsers: computed('feature', function() {
    return this.get('model.summarizedStatistic.registeredUsers');
  }),
  isUpdatingLocation: false,

  actions: {
    loginAction(){
      this.send('login');
    },
    startUpdateLocation(){
      this.toggleProperty('isUpdatingLocation');
    },
    style(feature) {
      return {
        fillColor: this.get('scale')(feature.properties.user_count_normalized).hex(),
        opacity: 1,
        weight: 2,
        dashArray: '5',
        color: 'white',
        fillOpacity: 0.7
      }
    },
    onEachFeature(feature, layer) {
      layer.on({
        mouseover: (e) => {
          let layer = e.target;
          layer.setStyle({
            weight: 5,
            dashArray: '',
            color: '#AAA',
          });
          layer.bringToFront();
          this.set('count', feature.properties.user_count_total);
          this.set('state', feature.properties.NAME_1);
        },
        click: (e) => {
          if (this.get('isUpdatingLocation')) {
            let user = this.get('model.user');
            user.set('coordinates', [e.latlng.lat, e.latlng.lng]);
            user.save().then(() => {
              this.set('isUpdatingLocation', false);
            });
          }
        },
        mouseout: (e) => {
          let layer = e.target;
          layer.setStyle({
            weight: 2,
            dashArray: '5',
            color: 'white',
          });
          this.set('count', null);
          this.set('state', null);
        },
      });
    },
  }
});
