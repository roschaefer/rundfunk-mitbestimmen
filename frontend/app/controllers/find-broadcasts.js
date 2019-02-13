import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import { alias, filterBy } from '@ember/object/computed';
import { computed } from '@ember/object';

export default Controller.extend({
  session: service(),
  intl: service(),
  queryParams: ['page', 'perPage', 'sort', 'q', 'medium', 'station'],
  sort: 'random',
  q: null,
  medium: null,
  station: null,
  filterParams: computed('q', 'medium', 'station', 'sort', function() {
    return {
      q: this.get('q'),
      sort: this.get('sort'),
      medium: this.get('medium'),
      station: this.get('station')
    }
  }),

  page: 1,
  perPage: 6,
  totalPages: alias("model.broadcasts.totalPages"),
  totalCount: alias("model.broadcasts.meta.total-count"),

  positiveImpressionsWithoutAmount: filterBy('model.impressions','needsAmount', true),

  // https://github.com/mharris717/ember-cli-pagination/issues/240#issuecomment-388406739
  broadcasts: computed.alias('model.broadcasts.content'),

  actions: {
    searchAction(filterParams){
      this.set('sort', filterParams.sort);
      this.set('q', filterParams.q);
      this.set('medium', filterParams.medium);
      this.set('station', filterParams.station);
      this.set('page', 1);
    },
    browse(step){
      this.set('page', step);
    },
    respond(broadcast){
      broadcast.get('impressions.firstObject').save();
    },
    clearBroadcast(){
      this.set('newBroadcast', this.store.createRecord('broadcast', {}));
    },
    loginAction(){
      this.send('login');
    },
    sortAction(direction){
      this.set('sort', direction);
      this.set('page', 1);
    }
  }
});