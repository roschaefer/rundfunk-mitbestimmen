import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  location: Ember.computed('latitude', 'longitude', function() {
    return [this.get('latitude'), this.get('longitude')];
  }),

});
