import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),
  intl: Ember.inject.service(),
  queryParams: ['mark_as_seen', 'page', 'perPage', 'sort', 'q', 'medium', 'station'],
  sort: 'random',
  q: null,
  medium: null,
  station: null,
  mark_as_seen: true,

  page: 1,
  perPage: 6,
  totalPages: Ember.computed.alias("content.broadcasts.totalPages"),

  positiveImpressionsWithoutAmount: Ember.computed.filterBy('model.impressions','needsAmount', true),

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
      this.get('filterParams').sort = direction;
    },
  }
});

