import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import EmberObject, { computed } from '@ember/object';
import { isNone } from '@ember/utils';
import d3 from 'd3';

export default Controller.extend({
  createTooltip(record){
    let a1 = record.get('approval')[0];
    let a2 = record.get('approval')[1];
    return [
      `title: ${record.get('title')}`,
      `approval: ${a1} => ${a2}`,
      `impressions: ${record.get('impressions')[0]} => ${record.get('impressions')[1]}`
    ].join('\n');
  },

  chartData: computed('model', function() {
    let approvalDeltas = this.get('model').map((record) => {
      return record.get('approvalDelta');
    });
    let min = d3.min(approvalDeltas);
    let max = d3.max(approvalDeltas);
    let colorScale = d3.scaleLinear()
      .domain([min, 0, max])
      .range(["deeppink", "lightskyblue", "limegreen"]);
    let colorFunction = (value) => {
      if (isNone(value)){
        return d3.color('tan');
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
