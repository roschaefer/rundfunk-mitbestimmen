import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';
import RouteMixin from 'ember-cli-pagination/remote/route-mixin';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import RSVP from 'rsvp';


export default Route.extend(RouteMixin, ResetScrollPositionMixin, {
  intl: service(),
  session: service(),
  seed: Math.random(),

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
    params.paramMapping = {
      total_pages: "total-pages"
    };
    params.include = ['impressions', 'stations', 'medium'];
    params.seed = this.get('seed');
    params.filter = {
      medium: params.medium,
      station: params.station
    };
    let store = this.get('store');
    return RSVP.hash({
      impressions: store.peekAll('impression'),
      broadcasts: this.findPaged('broadcast', params),
      media: store.findAll('medium'),
  stations: store.findAll('station')
    });
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
