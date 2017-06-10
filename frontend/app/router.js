import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL,
  metrics: Ember.inject.service(),

  didTransition() {
    this._super(...arguments);
    this._trackPage();
  },

  _trackPage() {
    Ember.run.scheduleOnce('afterRender', this, () => {
      const page = this.get('url');
      const title = this.getWithDefault('currentRouteName', 'unknown');

      Ember.get(this, 'metrics').trackPage({ page, title });
    });
  }
});

Router.map(function() {
  this.route('find-broadcasts');
  this.route('invoice');
  this.route('statistics');
  this.route('imprint');
  this.route('broadcasts');
  this.route('login');
  this.route('data-privacy');

  this.route('authentication', function() {
    this.route('callback');
  });
  this.route('visualize');
  this.route('about-us');
});

export default Router;
