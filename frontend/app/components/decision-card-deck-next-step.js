import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service('session'),
  tagName: '',
  additionalRepeatButtonClasses: Ember.computed('positiveReviews', function() {
    return (this.get('positiveReviews') > 1 ? '' :'primary');
  }),
  additionalDistributeButtonClasses: Ember.computed('positiveReviews', function() {
    return (this.get('positiveReviews') > 1 ? 'primary' :'');
  }),
  actions: {
    back(){
      this.get("back")();
    }
  }
});
