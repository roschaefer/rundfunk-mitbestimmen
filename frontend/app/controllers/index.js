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
          this.get('intl').t('index.goal.actual.series.events'),
          this.get('intl').t('index.goal.actual.series.family'),
          this.get('intl').t('index.goal.actual.series.series'),
          this.get('intl').t('index.goal.actual.series.culture'),
          this.get('intl').t('index.goal.actual.series.music'),
          this.get('intl').t('index.goal.actual.series.politics'),
          this.get('intl').t('index.goal.actual.series.presenation'),
          this.get('intl').t('index.goal.actual.series.quiz'),
          this.get('intl').t('index.goal.actual.series.religion'),
          this.get('intl').t('index.goal.actual.series.show'),
          this.get('intl').t('index.goal.actual.series.movie'),
          this.get('intl').t('index.goal.actual.series.sport'),
          this.get('intl').t('index.goal.actual.series.spot'),
        ],
      },
      yAxis: {
        title: {
          text: this.get('intl').t('index.goal.actual.yAxis'),
        }
      },
      tooltip: {
        pointFormat: '<b>{point.y:.3f} Mio. €</b>'
      },
    }
  }),
  actualChartData: Ember.computed('intl.locale', function() {
    return [{
      name:  this.get('intl').t('index.goal.actual.name.dasErste'),
      color: '#1e5b9a',
      data: [ 0, 114.9923, 262.7471, 50.9954, 1.6636, 309.7525, 0, 0, 10.0774, 225.5548, 213.7767, 461.8339, 3.6481]
    },{
      name:  this.get('intl').t('index.goal.actual.name.zdf'),
      color: '#fa7d19',
      data: [171.697, 36.490, 422.425, 86.055, 6.201, 172.130, 32.672, 32, 0, 160.639, 73.300, 368.039, 0]
    }];
  }),
});
