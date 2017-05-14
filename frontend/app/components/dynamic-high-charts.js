// components/dynamic-high-charts.js
import Ember from 'ember';
import EmberHighChartsComponent from 'ember-highcharts/components/high-charts';

export default EmberHighChartsComponent.extend({
  contentDidChange: Ember.observer('chartOptions.@each.isLoaded', function() {
    this.draw();
  })
});
