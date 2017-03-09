import DS from 'ember-data';

export default DS.Model.extend({
  query: DS.attr('string'),
  medium: DS.attr('number'),
  station: DS.attr('number'),
});
