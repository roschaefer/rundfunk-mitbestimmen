import { computed } from '@ember/object';
import DS from 'ember-data';

export default DS.Model.extend({
  broadcast: DS.belongsTo('broadcast'),
  response: DS.attr('string'),
  amount: DS.attr('number'),
  fixed: DS.attr('boolean'),
  createdAt: DS.attr('date'),
  updatedAt: DS.attr('date'),


  needsAmount: computed('amount', 'response', function() {
    return ((this.get('response') === 'positive') && (!this.get('amount')));
  }),

});
