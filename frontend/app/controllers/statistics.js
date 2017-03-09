import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  queryParams: ["page", "perPage", "column", "direction"],
  column: 'total',
  direction: 'desc',

  totalPagesBinding: 'model.totalPages',

  page: 1,
  perPage: 10,
  actions: {
    pageClicked(page) {
      this.set('page', page);
    },
    order(column){
      if (this.get('column') === column){
        if(this.get('direction') === 'desc'){
          this.set('direction', 'asc');
        } else{
          this.set('direction', 'desc');
        }
      }
      this.set('column', column);
    }
  }
});
