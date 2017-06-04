import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';


export default Ember.Route.extend(ResetScrollPositionMixin, {
  intl: Ember.inject.service(),
  session: Ember.inject.service('session'),
  queryParams: {
    q: {
      refreshModel: true
    },
    medium: {
      refreshModel: true
    },
    station: {
      refreshModel: true
    }
  },

  model(params) {
    return this.store.query('broadcast', {
      sort: 'random',
      q: params.q,
      filter: {
        review: 'unreviewed',
        medium: params.medium,
        station: params.station
      }
    });
  },
  afterModel(_, transition) {
    if (this.get('session').get('isAuthenticated') === false){
      const customDict = {
        networkOrEmail: {
          headerText: this.get('intl').t('decide.auth0-lock.networkOrEmail.headerText'),
          smallSocialButtonsHeader: this.get('intl').t('decide.auth0-lock.networkOrEmail.smallSocialButtonsHeader'),
          separatorText: this.get('intl').t('auth0-lock.networkOrEmail.separatorText'),
          footerText: this.get('intl').t('decide.auth0-lock.networkOrEmail.footerText'),
        },
      };
      transition.send('login', customDict);
    }
  },
  setupController: function(controller, model) {
    // Call _super for default behavior
    this._super(controller, model);
    // Implement your custom setup after
    controller.set('newBroadcast', this.store.createRecord('broadcast', {
      title: controller.get('q')
    }));
    controller.set('media', this.store.findAll('medium'));
    controller.set('stations', this.store.findAll('station'));
    controller.set('filterParams', this.store.createRecord('filterParams', {
      query: controller.get('q'),
      medium: controller.get('medium'),
      station: controller.get('station'),
    }));
  },
  resetController(controller, isExiting) {
    if (isExiting) {
      controller.set('q', null);
      controller.set('medium', null);
      controller.set('station', null);
    }
  },
  actions: {
    loading(transition) {
      let controller = this.controllerFor('decide');
      controller.set('loading', 'loading');
      transition.promise.finally(function() {
        controller.set('loading', '');
      });
    },
    setQuery(filterParams){
      this.get('controller').set( 'q', filterParams.get('query'));
      this.get('controller').set( 'medium', filterParams.get('medium'));
      this.get('controller').set('station', filterParams.get('station'));
    },
    newBroadcast(){
      this.get('controller').set('newBroadcast', this.store.createRecord('broadcast', {
      }));
    },
  }
});
