import Ember from 'ember';

export default Ember.Controller.extend({
  actualChartOptions: {
    chart: {
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: false,
      type: 'pie'
    },
    title: {
      text: ''
    },
    tooltip: {
      pointFormat: '<b>{point.y:.3f} Mio. € ({point.percentage:.1f}%</b>)'
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
  },
  actualChartData: [{
    innerSize: '50%',
    colorByPoint: true,
    data: [{
      name: 'Sport',
      y: 461.833
    }, {
      name: 'Politik & Gesellschaft',
      y: 309.752,
    }, {
      name: 'Fernsehspiel',
      y: 262.747
    }, {
      name: 'Unterhaltung',
      y: 225.554
    }, {
      name: 'Spielfilm',
      y: 213.776
    }, {
      name: 'Familie',
      y: 114.992
    }, {
      name: 'Kultur & Wissenschaft',
      y: 50.995
    }, {
      name: 'Religion',
      y: 10.074
    }, {
      name: 'Spot/Überleitung',
      y: 3.648
    }, {
      name: 'Musik',
      y: 1.663
    } ]
  }],
  targetChartOptions: {
    chart: {
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: false,
      type: 'pie'
    },
    title: {
      useHTML: true,
      text: '<h1>?</h1>',
      align: 'center',
      verticalAlign: 'middle',
      y: -40,
    },
    tooltip: {
      enabled: false,
    },
    legend: {
      margin: 40
    },
    plotOptions: {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: false
        },
        borderWidth: 0.5,
        borderColor: null,
        showInLegend: true,
      },
    },
  },
  targetChartData: [{
    innerSize: '50%',
    colorByPoint: true,
    data: [{
      name: 'Das gilt es herauszufinden',
      y: 1
    }]
  }]

});
