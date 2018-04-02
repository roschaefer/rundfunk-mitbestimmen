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
    xAxis: {
      title: {
        text: 'Anzahl Künstler'
      }
    },
    yAxis: {
      min: 0,
      max: 100,
      title: {
        text: 'Anteil Airplays',
      },
      labels: {
        formatter: function() {
          return this.value+"%";
        }
      }
    },
    tooltip: {
      pointFormat: '<b>{point.y:.1f}% aller Airplays</b>'
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
