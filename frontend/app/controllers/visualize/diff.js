import Ember from 'ember';

export default Ember.Controller.extend({
  intl: Ember.inject.service(),
  chartOptions: Ember.computed('model', 'intl.locale', function() {
    return {
      chart: {
        type: 'bar',
        height: this.get('model').get('categories').length * 30 + 250,
      },
      title: {
        text: ''
      },
      xAxis: {
        crosshair: true,
        categories: this.get('model').get('categories')
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

  chartData: Ember.computed('model', function() {
    return this.get('model').get('series');
  }),
});
