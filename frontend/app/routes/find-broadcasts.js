import Ember from 'ember';
import RouteMixin from 'ember-cli-pagination/remote/route-mixin';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';


export default Ember.Route.extend(RouteMixin, ResetScrollPositionMixin, {
  intl: Ember.inject.service(),
  session: Ember.inject.service('session'),
  seed: Math.random(),

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
  perPage: 6,

  model(params) {
    params.paramMapping = {
      total_pages: "total-pages"
    };
    params.sort = 'random';
    params.seed = this.get('seed');
    params.filter= {
      medium: params.medium,
      station: params.station
    };
    return RSVP.hash({
      selections: this.get('store').peekAll('selection'),
      broadcasts: this.findPaged('broadcast', params)
    });
  },
  afterModel(_, transition) {
    if (this.get('session').get('isAuthenticated') === false){
      const customDict = {
        networkOrEmail: {
          headerText: this.get('intl').t('find-broadcasts.auth0-lock.networkOrEmail.headerText'),
          smallSocialButtonsHeader: this.get('intl').t('find-broadcasts.auth0-lock.networkOrEmail.smallSocialButtonsHeader'),
          separatorText: this.get('intl').t('auth0-lock.networkOrEmail.separatorText'),
          footerText: this.get('intl').t('find-broadcasts.auth0-lock.networkOrEmail.footerText'),
        },
      };
      transition.send('login', customDict, 'find-broadcasts');
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
      let controller = this.controllerFor('find-broadcasts');
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
