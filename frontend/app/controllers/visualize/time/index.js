import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import { isNone } from '@ember/utils';
import { computed } from '@ember/object';
import chroma from 'chroma';

export default Controller.extend({
  intl: service(),
  approvalDeltas: computed('model.@each', function () {
    return this.get('model').map((record) => {
      return record.get('approvalDelta');
    });
  }),
  approvalDeltasLimits: computed('approvalDeltas', function () {
   return chroma.limits(this.get('approvalDeltas'), 'q', 4);
  }),
  missingDataLabel: computed('intl.locale', function() {
    return this.get('intl').t('visualize.time.bubble-chart-legend.missing-data');
  }),

  createTooltip(record){
    const options = {
      style: 'percent',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }
    let approvals = [];
    record.get('approval').forEach((a,i) => {
      approvals[i] = a ? this.get('intl').formatNumber(a, options) : '?';
    });
    return this.get('intl').t('visualize.time.tooltip', {
      title: record.get('title'),
      approvalBefore: approvals[0],
      approvalAfter: approvals[1],
      impressionsBefore: record.get('impressions')[0],
      impressionsAfter: record.get('impressions')[1]
    });
  },

  colorScale: computed('model', function() {
    return chroma
      .scale(chroma.scale('RdBu')
        .colors(5)
        .reverse()
      )
      .domain(this.get('approvalDeltasLimits'));
  }),
  nullColor: chroma('tan'),
  chartData: computed('model', 'intl.locale', function() {
    let colorFunction = (value) => {
      if (isNone(value)){
        return this.get('nullColor');
      }
      return this.get('colorScale')(value);
    };
    let textColor = (color) => {
        return chroma(color).get('lab.l') < 40 ? 'white' : 'black';
    }
    return this.get('model').map((record) => {
      const color = colorFunction(record.get('approvalDelta'));
      return Object.create({
        id: record.get('id'),
        color,
        textColor: textColor(color),
        label: record.get('title'),
        tooltip: this.createTooltip(record),
        size: record.get('impressionsDelta'),
      });
    });
  }),

  actions: {
    onClick(id) {
      this.transitionToRoute('visualize.time.progress', id);
    }
  }
});
