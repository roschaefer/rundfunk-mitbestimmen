import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Controller.extend({
  intl: service(),
  defaultChartOptions: computed('intl.locale', function() {
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

  defaultChartData: computed('intl.locale', function() {
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
});
