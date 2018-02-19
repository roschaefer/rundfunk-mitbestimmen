import Component from '@ember/component';

export default Component.extend({
  classNames: 'ui inline loader',
  classNameBindings: ['pagedContent.isFulfilled::active'],
  pagedContent: null,
});
