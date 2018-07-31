import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import Controller from '@ember/controller';
import { alias } from '@ember/object/computed';

export default Controller.extend({
  session: service('session'),
  queryParams: ["page", "perPage"],

  totalPagesBinding: alias("model.totalPages"),
  // https://github.com/mharris717/ember-cli-pagination/issues/240#issuecomment-388406739
  broadcasts: computed.alias('model.content'),
  broadcastsPaginator: computed.alias('model'),

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
