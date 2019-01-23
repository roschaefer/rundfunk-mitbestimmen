import Controller from '@ember/controller';
import { computed } from '@ember/object';
import { inject as controller } from '@ember/controller';

export default Controller.extend({
  diffController: controller('visualize/diff'),
  tvChartOptions: computed('diffController.defaultChartOptions', 'model.tv', function() {
    let chartOptions              = JSON.parse(JSON.stringify(this.get('diffController.defaultChartOptions'), true));
    chartOptions.chart.height     = this.get('model.tv').get('length') * 30 + 250;
    chartOptions.xAxis.categories = this.get('model.tv').map((station) => { return station.get('name')});
    return chartOptions;
  }),
  radioChartOptions: computed('diffController.defaultChartOptions', 'model.radio', function() {
    let chartOptions              = JSON.parse(JSON.stringify(this.get('diffController.defaultChartOptions'), true));
    chartOptions.chart.height     = this.get('model.radio').get('length') * 30 + 250;
    chartOptions.xAxis.categories = this.get('model.radio').map((station) => { return station.get('name')});
    return chartOptions;
  }),
  tvChartData: computed('diffController.defaultChartData', 'model.tv', function() {
    let chartData = JSON.parse(JSON.stringify(this.get('diffController.defaultChartData'), true));
    chartData[0].data = this.get('model.tv').map((station) => { return station.get('total')});
    chartData[1].data = this.get('model.tv').map((station) => { return station.get('expected_amount')});
    chartData[2].data = this.get('model.tv').map((station) => { return station.get('broadcasts_count')});
    return chartData;
  }),
  radioChartData: computed('diffController.defaultChartData', 'model.radio', function() {
    let chartData = JSON.parse(JSON.stringify(this.get('diffController.defaultChartData'), true));
    chartData[0].data = this.get('model.radio').map((station) => { return station.get('total')});
    chartData[1].data = this.get('model.radio').map((station) => { return station.get('expected_amount')});
    chartData[2].data = this.get('model.radio').map((station) => { return station.get('broadcasts_count')});
    return chartData;
  }),
});
