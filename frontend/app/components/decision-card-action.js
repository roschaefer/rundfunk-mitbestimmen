import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'button',
  classNames: ['decision-card-action ui button'],
  classNameBindings: [
    'responsePositive:right:left',
    'responsePositive:labeled:labeled',
    'responsePositive:icon:icon',
    'responsePositive:positive:neutral'
  ],
  click(){
    let decideAction = this.get('decideAction');
    if (this.get('responsePositive')) {
      decideAction('positive');
    } else {
      decideAction('neutral');
    }
  }
});
