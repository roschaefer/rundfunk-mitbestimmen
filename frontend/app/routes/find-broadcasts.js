import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';
import RouteMixin from 'ember-cli-pagination/remote/route-mixin';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';


export default Route.extend(RouteMixin, ResetScrollPositionMixin, {
  intl: service(),
  session: service(),
  fastboot: service(),
  clientSeed: Math.random,

  queryParams: {
    sort: {
      refreshModel: true
    },
    q: {
      refreshModel: true
    },
    medium: {
      refreshModel: true
    },
    station: {
      refreshModel: true
    },
    page: {
      refreshModel: true
    }
  },

  model(params) {
    let shoebox = this.get('fastboot.shoebox');
    let shoeboxStore = shoebox.retrieve('random-store');
    let isFastBoot = this.get('fastboot.isFastBoot');

    if (isFastBoot) {
      if (!shoeboxStore) {
        shoeboxStore = {};
        shoebox.put('random-store', shoeboxStore);
      }
      shoeboxStore['seed'] = Math.random();
    }
    const seed = shoeboxStore && shoeboxStore['seed'] || this.clientSeed;

    params.paramMapping = {
      total_pages: "total-pages"
    };
    params.include = ['impressions', 'stations', 'medium'];
    params.seed = seed;
    params.filter = {
      medium: params.medium,
      station: params.station
    };
    return RSVP.hash({
      impressions: this.get('store').peekAll('impression'),
      broadcasts: this.findPaged('broadcast', params),
      media: this.store.findAll('medium'),
      stations:this.store.findAll('station')
    });
  },
  setupController: function(controller, model) {
    // Call _super for default behavior
    this._super(controller, model);
    // Implement your custom setup after
    controller.set('newBroadcast', this.store.createRecord('broadcast', {
      title: controller.get('q')
    }));
  },
  resetController(controller, isExiting) {
    if (isExiting) {
      controller.set('q', null);
      controller.set('medium', null);
      controller.set('station', null);
      controller.set('sort', 'random');
    }
  },
  actions: {
    loading(transition) {
      let controller = this.controllerFor('find-broadcasts');
      controller.set('loading', true);
      transition.promise.finally(function() {
        controller.set('loading', false);
      });
    },
  }
});
