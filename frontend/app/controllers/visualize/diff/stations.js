import Ember from 'ember';

export default Ember.Controller.extend({
  diffController: Ember.inject.controller('visualize/diff'),
  tvChartOptions: Ember.computed('diffController.defaultChartOptions', 'model.tv', function() {
    let chartOptions              = Ember.copy(this.get('diffController.defaultChartOptions'), true);
    chartOptions.chart.height     = this.get('model.tv').get('length') * 30 + 250;
    chartOptions.xAxis.categories = this.get('model.tv').map((station) => { return station.get('name')});
    return chartOptions;
  }),
  radioChartOptions: Ember.computed('diffController.defaultChartOptions', 'model.radio', function() {
    let chartOptions              = Ember.copy(this.get('diffController.defaultChartOptions'), true);
    chartOptions.chart.height     = this.get('model.radio').get('length') * 30 + 250;
    chartOptions.xAxis.categories = this.get('model.radio').map((station) => { return station.get('name')});
    return chartOptions;
  }),
  tvChartData: Ember.computed('diffController.defaultChartData', 'model.tv', function() {
    let chartData = Ember.copy(this.get('diffController.defaultChartData'), true);
    chartData[0].data = this.get('model.tv').map((station) => { return station.get('total')});
    chartData[1].data = this.get('model.tv').map((station) => { return station.get('expected_amount')});
    chartData[2].data = this.get('model.tv').map((station) => { return station.get('broadcasts_count')});
    return chartData;
  }),
  radioChartData: Ember.computed('diffController.defaultChartData', 'model.radio', function() {
    let chartData = Ember.copy(this.get('diffController.defaultChartData'), true);
    chartData[0].data = this.get('model.radio').map((station) => { return station.get('total')});
    chartData[1].data = this.get('model.radio').map((station) => { return station.get('expected_amount')});
    chartData[2].data = this.get('model.radio').map((station) => { return station.get('broadcasts_count')});
    return chartData;
  }),
});
