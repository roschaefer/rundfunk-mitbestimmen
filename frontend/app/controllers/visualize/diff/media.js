import Controller from '@ember/controller';
import { computed } from '@ember/object';
import { copy } from '@ember/object/internals';
import { inject as controller } from '@ember/controller';

export default Controller.extend({
  diffController: controller('visualize/diff'),
  mediaChartOptions: computed('diffController.defaultChartOptions', 'model', function() {
    let chartOptions              = copy(this.get('diffController.defaultChartOptions'), true);
    chartOptions.chart.height     = this.get('model').get('length') * 30 + 250;
    chartOptions.xAxis.categories = this.get('model').map((medium) => { return medium.get('name')});
    return chartOptions;
  }),
  mediaChartData: computed('diffController.defaultChartData', 'model', function() {
    let chartData = copy(this.get('diffController.defaultChartData'), true);
    chartData[0].data = this.get('model').map((medium) => { return medium.get('total')});
    chartData[1].data = this.get('model').map((medium) => { return medium.get('expected_amount')});
    chartData[2].data = this.get('model').map((medium) => { return medium.get('broadcasts_count')});
    return chartData;
  }),
});
