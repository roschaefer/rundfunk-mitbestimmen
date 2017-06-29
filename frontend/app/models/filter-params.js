import DS from 'ember-data';

export default DS.Model.extend({
  sort: DS.attr('string'),
  query: DS.attr('string'),
  medium: DS.attr('number'),
  station: DS.attr('number'),
});
