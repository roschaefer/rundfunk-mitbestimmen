import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import EmberObject, { computed } from '@ember/object';
import { isNone } from '@ember/utils';
import chroma from 'chroma';

export default Controller.extend({
  intl: service(),
  approvalDeltas: computed('model.@each', function () {
    return this.get('model').map((record) => {
      return record.get('approvalDelta');
    });
  }),
  maxApproval: computed.max('approvalDeltas'),
  minApproval: computed.min('approvalDeltas'),

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
    return [
      `${this.get('intl').t('statistics.summary.table.header.broadcast')}: ${record.get('title')}`,
      `${this.get('intl').t('statistics.summary.table.header.approval')}: ${approvals[0]} => ${approvals[1]}`,
      `${this.get('intl').t('statistics.summary.table.header.impressions')}: ${record.get('impressions')[0]} => ${record.get('impressions')[1]}`
    ].join('\n');
  },

  chartData: computed('model', 'intl.locale', function() {
    let colorScale = chroma
      .scale(["deeppink", "lightblue", "limegreen"])
      .domain([this.get('minApproval'), 0, this.get('maxApproval')]);
    let colorFunction = (value) => {
      if (isNone(value)){
        return chroma('tan');
      }
      return colorScale(value);
    };
    return this.get('model').map((record) => {
      return Object.create({
        id: record.get('id'),
        color: colorFunction(record.get('approvalDelta')),
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
