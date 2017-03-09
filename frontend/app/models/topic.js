import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  broadcasts: DS.hasMany('broadcast')
});
