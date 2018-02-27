import DS from 'ember-data';
import { computed } from '@ember/object';
import { isNone } from '@ember/utils';


export default DS.Model.extend({
  title: DS.attr('string'),
  impressions: DS.attr(),
  approval: DS.attr(),
  average: DS.attr(),
  total: DS.attr(),

  delta(attribute, checkNull){
    let before = this.get(attribute)[0], after = this.get(attribute)[1];
    if (checkNull && (isNone(before) || isNone(after))){
      return null;
    }
    return after - before;
  },
  impressionsDelta: computed('impressions', function() {
    return this.delta('impressions');
  }),
  approvalDelta: computed('approval', function() {
    return this.delta('approval', true);
  }),
  averageDelta: computed('average', function() {
    return this.delta('average', true);
  }),
  totalDelta: computed('total', function() {
    return this.delta('total');
  }),
});
