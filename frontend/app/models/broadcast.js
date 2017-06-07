import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  title: DS.attr('string'),
  description: DS.attr('string'),
  medium: DS.belongsTo('medium'),
  station: DS.belongsTo('station'),
  selections: DS.hasMany('selection'),

  response: Ember.computed('selections.firstObject.response', function() {
    return this.get('selections.firstObject.response');
  }),

  setDefaultResponse(response){
    return this.get('selections.firstObject') || this.respond(response);
  },
  respond(response){
    let firstSelection = this.get('selections.firstObject');
    if (['positive', 'neutral'].includes(response)){
      if (firstSelection){
        firstSelection.set('response', response);
        if (response === 'neutral'){
          firstSelection.set('amount', null);
          firstSelection.set('fixed', false);
        }
      } else {
        firstSelection = this.get('store').createRecord('selection', {
          broadcast: this,
          response: response,
        });
        this.get('selections').addObject(firstSelection);
      }
    }
    return firstSelection;
  },

  saveAndSetSuccess(){
    this.save().then(() => {
      this.set('success', true);
    }).catch(() => {
      this.set('success', false);
    });
  }
});
