import Ember from 'ember';

export default Ember.Controller.extend({
  intl: Ember.inject.service(),
  defaultChartOptions: Ember.computed('intl.locale', function() {
    return {
      chart: {
        type: 'bar'
      },
      title: {
        text: ''
      },
      xAxis: {
        crosshair: true,
      },
      yAxis: [{
        title: {
          text: this.get('intl').t('visualize.diff.chart.yAxis.amount_per_month')
        },
      }, {
        title: {
          text: this.get('intl').t('visualize.diff.chart.yAxis.number_of_broadcasts')
        },
        opposite: true,
      }],
      tooltip: {
        shared: true
      },
      legend: {
        layout: 'horizontal',
        verticalAlign: 'top'
      }
    };
  }),
  tvChartOptions: Ember.computed('defaultChartOptions', 'model.tv', function() {
    let chartOptions              = Ember.copy(this.get('defaultChartOptions'), true);
    chartOptions.chart.height     = this.get('model.tv.categories').length * 30 + 250;
    chartOptions.xAxis.categories = this.get('model.tv.categories');
    return chartOptions;
  }),
  radioChartOptions: Ember.computed('defaultChartOptions', 'model.radio', function() {
    let chartOptions              = Ember.copy(this.get('defaultChartOptions'), true);
    chartOptions.chart.height     = this.get('model.radio.categories').length * 30 + 250;
    chartOptions.xAxis.categories = this.get('model.radio.categories');
    return chartOptions;
  }),
  tvChartData: Ember.computed('model.tv', function() {
    return this.get('model.tv.series');
  }),
  radioChartData: Ember.computed('model.radio', function() {
    return this.get('model.radio.series');
  }),
});
