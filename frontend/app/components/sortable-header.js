import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({
  tagName: 'th',
  classNameBindings: [
    'sorted',
    'asc:ascending',
    'desc:descending',
  ],
  sorted: computed('current-column', function() {
    return this.get('current-column') === this.get('column');
  }),
  asc: computed('current-direction', function() {
    return this.get('current-direction') === 'asc';
  }),
  desc: computed('current-direction', function() {
    return this.get('current-direction') === 'desc';
  }),
  click(){
    this.get('clickAction')(this.get('column'));
  }
});

