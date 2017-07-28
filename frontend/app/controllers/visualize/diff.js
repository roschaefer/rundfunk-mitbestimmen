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
          text: this.get('intl').t('visualize.diff.chart.yAxis.amount-per-month'),
          align: 'low',
          style: {
            fontWeight: 'bold',
            fontSize: '16px'
          }
        }
      }, {
        title: {
          text: this.get('intl').t('visualize.diff.chart.yAxis.number-of-broadcasts'),
          align: 'low',
          style: {
            fontWeight: 'bold',
            fontSize: '16px'
          }
        },
        opposite: true,
      }],
      tooltip: {
        shared: true
      },
      legend: {
        layout: 'vertical',
        align: 'right',
        floating: true,
        verticalAlign: 'middle'
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

  defaultChartData: Ember.computed('intl.locale', function() {
    return [{
        name: this.get('intl').t('visualize.diff.chart.yAxis.actual-amount'),
        tooltip: { valueSuffix: '€', valueDecimals: 2 },
        yAxis: 0,
        type: 'column'
      }, {
        name: this.get('intl').t('visualize.diff.chart.yAxis.expected-amount'),
        tooltip: { valueSuffix: '€', valueDecimals: 2 },
        yAxis: 0,
        type: 'column'
      }, {
        name: this.get('intl').t('visualize.diff.chart.yAxis.number-of-broadcasts'),
        marker: { enabled: false},
        yAxis: 1,
        type: 'spline',
      }
    ]
  }),
  tvChartData: Ember.computed('defaultChartData', 'model.tv', function() {
    let chartData = Ember.copy(this.get('defaultChartData'), true);
    chartData[0].data = this.get('model.tv.series').objectAt(0).data;
    chartData[1].data = this.get('model.tv.series').objectAt(1).data;
    chartData[2].data = this.get('model.tv.series').objectAt(2).data;
    return chartData;
  }),
  radioChartData: Ember.computed('defaultChartData', 'model.radio', function() {
    let chartData = Ember.copy(this.get('defaultChartData'), true);
    chartData[0].data = this.get('model.radio.series').objectAt(0).data;
    chartData[1].data = this.get('model.radio.series').objectAt(1).data;
    chartData[2].data = this.get('model.radio.series').objectAt(2).data;
    return chartData;
  }),
});
