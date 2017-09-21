import Ember from 'ember';

export default Ember.Controller.extend({
  diffController: Ember.inject.controller('visualize/diff'),
  mediaChartOptions: Ember.computed('diffController.defaultChartOptions', 'model', function() {
    let chartOptions              = Ember.copy(this.get('diffController.defaultChartOptions'), true);
    chartOptions.chart.height     = this.get('model').get('length') * 30 + 250;
    chartOptions.xAxis.categories = this.get('model').map((medium) => { return medium.get('name')});
    return chartOptions;
  }),
  mediaChartData: Ember.computed('diffController.defaultChartData', 'model', function() {
    let chartData = Ember.copy(this.get('diffController.defaultChartData'), true);
    chartData[0].data = this.get('model').map((medium) => { return medium.get('total')});
    chartData[1].data = this.get('model').map((medium) => { return medium.get('expected_amount')});
    chartData[2].data = this.get('model').map((medium) => { return medium.get('broadcasts_count')});
    return chartData;
  }),
});
