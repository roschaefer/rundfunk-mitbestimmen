import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Controller.extend({
  session: service(),
  init() {
    this._super(...arguments);
    this.set('categories',[
       '100 + ', '95-99', '90-94', '85-89', '80-84', '75-79','70-74',
       '65-69','60-64', '55-59', '50-54', '45-49', '40-44', '35-39', '30-34',
       '25-29', '20-24',  '15-19',  '10-14',  '5-9', '0-4',]);
    },

    categories: null,

    chartOptions: computed( function() {
      return {
        chart: {
          type: 'bar'
        },
        title: {
          text: ''
        },
        xAxis: {
          categories: this.get('categories')
        },
        yAxis: {
          title: {
          text: null
        },
          labels: {
            formatter: function () {
              return Math.abs(this.value) + '%';
            }
          }
        },
        legend: {
          reversed: true
        },
        plotOptions: {
          series: {
            stacking: 'normal'
          }
        },
        series: [{
          name: 'Female',
          data: [2.1, 2.0, 2.2, 2.4, 2.6, 3.0, 3.1, 2.9,
            3.1, 4.1, 4.3, 3.6, 3.4, 2.6, 2.9, 2.9,
            1.8, 1.2, 0.6, 0.1, 0.0]
        }, {
          name: 'Non-binary',
          data: [0.3, 0.4, 0.2, 0.6, 2, 3.4, 1.2, 1.4]
        }, {
          name: 'Male',
          data: [2.2, 2.2, 2.3, 2.5, 2.7, 3.1, 3.2,
            3.0, 3.2, 4.3, 4.4, 3.6, 3.1, 2.4,
            2.5, 2.3, 1.2, 0.6, 0.2, 0.0, 0.0]
        }]
      };
    }),


      chartData: computed( function() {
        return [{
          name: 'male',
          data: [-2.2, -2.2, -2.3, -2.5, -2.7, -3.1, -3.2,
            -3.0, -3.2, -4.3, -4.4, -3.6, -3.1, -2.4,
            -2.5, -2.3, -1.2, -0.6, -0.2, -0.0, -0.0]
          }, {
            name: 'female',
            data: [2.1, 2.0, 2.2, 2.4, 2.6, 3.0, 3.1, 2.9,
              3.1, 4.1, 4.3, 3.6, 3.4, 2.6, 2.9, 2.9,
              1.8, 1.2, 0.6, 0.1, 0.0]
            }]
          }),
        });
