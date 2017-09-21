import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  broadcasts_count: DS.attr('number'),
  total: DS.attr('number'),
  expected_amount: DS.attr('number'),
});
