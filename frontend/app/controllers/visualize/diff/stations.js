import Ember from 'ember';

export default Ember.Controller.extend({
  diffController: Ember.inject.controller('visualize/diff'),
  tvChartOptions: Ember.computed('diffController.defaultChartOptions', 'model.tv', function() {
    let chartOptions              = Ember.copy(this.get('diffController.defaultChartOptions'), true);
    chartOptions.chart.height     = this.get('model.tv.categories').length * 30 + 250;
    chartOptions.xAxis.categories = this.get('model.tv.categories');
    return chartOptions;
  }),
  radioChartOptions: Ember.computed('diffController.defaultChartOptions', 'model.radio', function() {
    let chartOptions              = Ember.copy(this.get('diffController.defaultChartOptions'), true);
    chartOptions.chart.height     = this.get('model.radio.categories').length * 30 + 250;
    chartOptions.xAxis.categories = this.get('model.radio.categories');
    return chartOptions;
  }),
  tvChartData: Ember.computed('diffController.defaultChartData', 'model.tv', function() {
    let chartData = Ember.copy(this.get('diffController.defaultChartData'), true);
    chartData[0].data = this.get('model.tv.series').objectAt(0).data;
    chartData[1].data = this.get('model.tv.series').objectAt(1).data;
    chartData[2].data = this.get('model.tv.series').objectAt(2).data;
    return chartData;
  }),
  radioChartData: Ember.computed('diffController.defaultChartData', 'model.radio', function() {
    let chartData = Ember.copy(this.get('diffController.defaultChartData'), true);
    chartData[0].data = this.get('model.radio.series').objectAt(0).data;
    chartData[1].data = this.get('model.radio.series').objectAt(1).data;
    chartData[2].data = this.get('model.radio.series').objectAt(2).data;
    return chartData;
  }),
});
