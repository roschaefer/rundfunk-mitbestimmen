import EmberRouter from '@ember/routing/router';
import { inject as service } from '@ember/service';
import { scheduleOnce } from '@ember/runloop';
import { get } from '@ember/object';
import config from './config/environment';

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL,
  metrics: service(),

  didTransition() {
    this._super(...arguments);
    this._trackPage();
  },

  _trackPage() {
    scheduleOnce('afterRender', this, () => {
      const page = this.get('url');
      const title = this.getWithDefault('currentRouteName', 'unknown');

      get(this, 'metrics').trackPage({ page, title });
    });
  }
});

Router.map(function() {
  this.route('find-broadcasts');
  this.route('invoice');
  this.route('statistics');
  this.route('imprint');
  this.route('history');
  this.route('login');
  this.route('data-privacy');
  this.route('faq', function() {
    this.route('show', { path: '/:slug' });
  });

  this.route('authentication', function() {
    this.route('callback');
  });
  this.route('visualize', function() {
    this.route('geo');
    this.route('diff', function() {
      this.route('media');
      this.route('stations');
    });
    this.route('graph');
    this.route('time', function() {
      this.route('progress', { path: '/progress/:broadcast_id' });
    });
    this.route('demography');
  });
  this.route('about-us');
  this.route('broadcast', { path: '/broadcast/:broadcast_id' }, function() {
    this.route('edit');
  });
  this.route('404', { path: '*' });
});

export default Router;
