import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  votes: DS.attr('number'),
  approval: DS.attr('number'),
  average: DS.attr('number'),
  total: DS.attr('number'),
});
