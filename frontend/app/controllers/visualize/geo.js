import Ember from 'ember';

export default Ember.Controller.extend({
  lat: 51.520008,
  lng: 10,
  zoom: 6,
  tileLayerUrl: 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
});
