import Ember from 'ember';

export default Ember.Controller.extend({
  intl: Ember.inject.service(),
  actualChartOptions: Ember.computed('intl.locale', function() {
    return {
      chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: 'column'
      },
      title: {
        text: ''
      },
      yAxis: {
        title: {
          text: this.get('intl').t('index.goal.actual.yAxis'),
        }
      },
      tooltip: {
        pointFormat: '<b>{point.y:.3f} Mio. €</b>'
      },
      legend: {
        itemDistance: 10
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: false
          },
          showInLegend: true,
        }
      },
    }
  }),
  actualChartData: Ember.computed('intl.locale', function() {
    return [{
      innerSize: '50%',
      colorByPoint: true,
      name:  this.get('intl').t('index.goal.actual.name'),
      data: [{
        name:  this.get('intl').t('index.goal.actual.series.sport'),
        y: 461.833
      }, {
        name:  this.get('intl').t('index.goal.actual.series.politics'),
        y: 309.752,
      }, {
        name:  this.get('intl').t('index.goal.actual.series.television-play'),
        y: 262.747
      }, {
        name:  this.get('intl').t('index.goal.actual.series.entertainment'),
        y: 225.554
      }, {
        name:  this.get('intl').t('index.goal.actual.series.movie'),
        y: 213.776
      }, {
        name:  this.get('intl').t('index.goal.actual.series.family'),
        y: 114.992
      }, {
        name:  this.get('intl').t('index.goal.actual.series.culture'),
        y: 50.995
      }, {
        name:  this.get('intl').t('index.goal.actual.series.religion'),
        y: 10.074
      }, {
        name:  this.get('intl').t('index.goal.actual.series.spot'),
        y: 3.648
      }, {
        name:  this.get('intl').t('index.goal.actual.series.music'),
        y: 1.663
      } ]
    }];
  }),
});
