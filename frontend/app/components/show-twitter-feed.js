import Component from '@ember/component';

export default Component.extend({
  tag: 'div',
  classNames: ['ui one column grid'],
  isFetching: true,
  actions:{
    isFetchingTwitterFeed() {
        this.set('isFetching', false);
      }
  }
});
