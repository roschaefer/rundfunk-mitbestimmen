import Controller from '@ember/controller';
import { computed } from '@ember/object';

export default Controller.extend({
  chartOptions: {
    chart: {
      type: 'spline'
    },
    title: {
      text: ''
    },
    yAxis: {
      title: {
        text: 'yAxis',
      }
    },
    plotOptions: {
      series: {
        pointStart: 1
      }
    },
  },
  chartData: computed('model', function() {
    return Object.keys(this.get('model')).map((key) => {
      let series = this.get('model')[key];
      return {
        name:  key,
        data: series
      };
    });
  })
});
