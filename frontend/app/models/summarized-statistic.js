import DS from 'ember-data';

export default DS.Model.extend({
  broadcasts: DS.attr('number'),
  registeredUsers: DS.attr('number'),
  impressions: DS.attr('number'),
  assignedMoney: DS.attr('number'),
});
