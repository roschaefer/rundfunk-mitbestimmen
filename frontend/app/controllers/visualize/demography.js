import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import { alias } from '@ember/object/computed';

export default Controller.extend({
  session: service(),
  intl: service(),
  demography: service(),
  categories: alias('demography.ageGroupLabels'),

  chartOptions: computed( function() {
    return {
      chart: {
        type: 'bar'
      },
      title: {
        text: ''
      },
      xAxis: [{
        categories: this.get('demography').get('ageGroups'),
        reversed: false,
        labels: {
          step: 1
        }
      }, { // mirror axis on right side
        categories: this.get('demography').get('ageGroups'),
        opposite: true,
        reversed: false,
        linkedTo: 0,
        labels: {
          step: 1
        }
      }],
      yAxis: {
        title: {
          text: null
        },
        labels: {
          formatter: function() {
            return Math.abs(this.value) + '%';
          }
        }
      },
      plotOptions: {
        series: {
          stacking: 'normal'
        }
      },
      tooltip: {
        formatter: function () {
          return '<b>' + this.series.name + ', age ' + this.point.category + '</b><br/>' +
            'Population: ' + Math.abs(this.point.y).toFixed(2) + '%';
        }
      }
    };
  }),


  chartData: computed('intl.locale', function() {
    return [{
      name: this.get('intl').t('visualize.demography.chart.labels.female'),
      data: [
        2.1, 2.0, 2.1, 2.3, 2.6,
        2.9, 3.2, 3.1, 2.9, 3.4,
        4.3, 4.0, 3.5, 2.9, 2.5,
        2.7, 2.2, 1.1, 0.6, 0.2,
        0.0
      ]
    }, {
      name: this.get('intl').t('visualize.demography.chart.labels.male'),
      data: [
        -2.2, -2.1, -2.2, -2.4,
        -2.7, -3.0, -3.3, -3.2,
        -2.9, -3.5, -4.4, -4.1,
        -3.4, -2.7, -2.3, -2.2,
        -1.6, -0.6, -0.3, -0.0,
        -0.0
      ]
    },{
      name: this.get('intl').t('visualize.demography.chart.labels.other'),
      data: []
    }];
  })
});
