import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  title: DS.attr('string'),
  description: DS.attr('string'),
  medium: DS.belongsTo('medium'),
  station: DS.belongsTo('station'),
  selections: DS.hasMany('selection'),

  response: Ember.computed('selections', function() {
    let firstSelection = this.get('selections.firstObject');
    if (firstSelection) {
      return firstSelection.get('response');
    } else {
      return 'neutral';
    }
  }),
  respond(response){
    let selection = this.get('selections').objectAt(0);
    if ((response !== 'positive') && (response !== 'neutral')){
      return selection;
    } else {
      if (selection){
        selection.set('response', response);
        if (response === 'neutral'){
          selection.set('amount', null);
          selection.set('fixed', false);
        }
      } else {
        selection = this.get('store').createRecord('selection', {
          broadcast: this,
          response: response,
        });
        this.get('selections').addObject(selection);
      }
      return selection;
    }
  },

  saveAndSetSuccess(){
    this.save().then(() => {
      this.set('success', true);
    }).catch(() => {
      this.set('success', false);
    });
  }
});
