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
  totalPages: alias("content.broadcasts.totalPages"),

  positiveImpressionsWithoutAmount: filterBy('model.impressions','needsAmount', true),

  actions: {
    searchAction(query){
      this.send('setQuery', query);
      this.set('page', 1);
    },
    browse(step){
      this.set('page', step);
    },
    respond(broadcast){
      broadcast.get('impressions.firstObject').save();
    },
    loginAction(){
      const customDict = {
        networkOrEmail: {
          headerText: this.get('intl').t('find-broadcasts.auth0-lock.networkOrEmail.headerText'),
          smallSocialButtonsHeader: this.get('intl').t('find-broadcasts.auth0-lock.networkOrEmail.smallSocialButtonsHeader'),
          separatorText: this.get('intl').t('auth0-lock.networkOrEmail.separatorText'),
        },
      };
      this.send('login', customDict, 'find-broadcasts');
    },
    sortBroadcasts(direction) {
      this.set('sort', direction);
    },
    clearBroadcast(){
      this.set('newBroadcast', this.store.createRecord('broadcast', {}));
    }
  }
});

