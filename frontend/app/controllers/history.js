import { inject as service } from '@ember/service';
import Controller from '@ember/controller';
import { alias } from '@ember/object/computed';

export default Controller.extend({
  session: service('session'),
  queryParams: ["page", "perPage"],

  totalPagesBinding: alias("model.totalPages"),

  page: 1,
  perPage: 10,
  actions: {
    pageClicked(page) {
      this.set('page', page);
    },
    unselect(broadcast){
      let impression = broadcast.respond('neutral');
      impression.save();
    },
    reselect(broadcast){
      let impression = broadcast.respond('positive');
      impression.save();
    },
  }
});
