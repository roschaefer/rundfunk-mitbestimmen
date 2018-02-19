// components/dynamic-high-charts.js
import EmberHighChartsComponent from 'ember-highcharts/components/high-charts';
import { observer } from '@ember/object';

export default EmberHighChartsComponent.extend({
  contentDidChange: observer('chartOptions.@each.isLoaded', function() {
    this.draw();
  })
});
