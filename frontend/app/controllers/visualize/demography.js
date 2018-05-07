import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Controller.extend({

  session: service(),
  init() {
    this._super(...arguments);
    this.set('categories',[
      '0-4', '5-9', '10-14', '15-19',
      '20-24', '25-29', '30-34', '35-39', '40-44',
      '45-49', '50-54', '55-59', '60-64', '65-69',
      '70-74', '75-79', '80-84', '85-89', '90-94',
      '95-99', '100 + ']);
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
      subtitle: {
        text: ''
      },
      yAxis: {
          min: 0,
          title: {
              text: 'Age group'
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
          name: 'Male',
          data: [5, 3, 4, 7, 2]
      }, {
          name: 'Female',
          data: [2, 2, 3, 2, 1]
      }, {
          name: 'Non-Binary',
          data: [3, 4, 4, 2, 5]
      }]
    }
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
