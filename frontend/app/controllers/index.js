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
      xAxis:{
        categories: [
          this.get('intl').t('index.actual.series.quiz'),
          this.get('intl').t('index.actual.series.spot'),
          this.get('intl').t('index.actual.series.music'),
          this.get('intl').t('index.actual.series.religion'),
          this.get('intl').t('index.actual.series.presenation'),
          this.get('intl').t('index.actual.series.culture'),
          this.get('intl').t('index.actual.series.family'),
          this.get('intl').t('index.actual.series.events'),
          this.get('intl').t('index.actual.series.movie'),
          this.get('intl').t('index.actual.series.show'),
          this.get('intl').t('index.actual.series.politics'),
          this.get('intl').t('index.actual.series.series'),
          this.get('intl').t('index.actual.series.sport'),
        ],
      },
      yAxis: {
        title: {
          text: this.get('intl').t('index.actual.yAxis'),
        }
      },
      tooltip: {
        pointFormat: '<b>{point.y:.3f} Mio. €</b>'
      },
    }
  }),
  actualChartData: Ember.computed('intl.locale', function() {
    return [{
      name:  this.get('intl').t('index.actual.name.dasErste'),
      color: '#1e5b9a',
      data: [ 0, 3.6481, 1.6636, 10.0774, 0, 50.9954, 114.9923, 0, 213.7767, 225.5548, 309.7525, 262.7471, 461.8339 ]
    },{
      name:  this.get('intl').t('index.actual.name.zdf'),
      color: '#fa7d19',
      data: [ 0.03, 0, 6.20, 0, 32.67, 86.06, 36.49, 171.70, 73.30, 160.64, 172.13, 422.425, 368.04 ]
    }];
  }),
});
