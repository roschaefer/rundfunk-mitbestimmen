import DS from 'ember-data';
import { computed } from '@ember/object';


export default DS.Model.extend({
  title: DS.attr('string'),
  impressions: DS.attr(),
  approval: DS.attr(),
  average: DS.attr(),
  total: DS.attr(),

  impressionsDelta: computed('impressions', function() {
    return this.get('impressions')[1] - this.get('impressions')[0];
  })
});
