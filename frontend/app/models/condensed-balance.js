import DS from 'ember-data';

export default DS.Model.extend({
  broadcasts: DS.attr('number'),
  registeredUsers: DS.attr('number'),
  reviews: DS.attr('number'),
  assignedMoney: DS.attr('number'),
});
