import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  queryParams: ["page", "perPage"],

  totalPagesBinding: 'model.totalPages',

  page: 1,
  perPage: 10,
  actions: {
    pageClicked(page) {
      this.set('page', page);
    },
    unselect(broadcast){
      let selection = broadcast.respond('neutral');
      selection.save();
    },
    reselect(broadcast){
      let selection = broadcast.respond('positive');
      selection.save();
    },
    edit(broadcast){
      this.set('editedBroadcast', broadcast);
      Ember.$('.ui.broadcast-form-modal.modal').modal('show');
    },
  }
});
