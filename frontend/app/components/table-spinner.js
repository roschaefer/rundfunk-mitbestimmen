import Ember from 'ember';

export default Ember.Component.extend({
  classNames: 'ui inline loader',
  classNameBindings: ['pagedContent.isFulfilled::active'],
  pagedContent: null,
});
