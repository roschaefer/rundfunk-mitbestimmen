import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'th',
  classNameBindings: [
    'sorted',
    'asc:ascending',
    'desc:descending',
  ],
  sorted: Ember.computed('current-column', function() {
    return this.get('current-column') === this.get('column');
  }),
  asc: Ember.computed('current-direction', function() {
    return this.get('current-direction') === 'asc';
  }),
  desc: Ember.computed('current-direction', function() {
    return this.get('current-direction') === 'desc';
  }),
  click(){
    this.get('clickAction')(this.get('column'));
  }
});

