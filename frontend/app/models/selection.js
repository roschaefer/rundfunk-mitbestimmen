import DS from 'ember-data';

export default DS.Model.extend({
  broadcast: DS.belongsTo('broadcast'),
  response: DS.attr('string'),
  amount: DS.attr('number'),
  fixed: DS.attr('boolean'),
});
