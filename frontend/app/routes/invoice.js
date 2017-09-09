import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';


export default Ember.Route.extend(AuthenticatedRouteMixin, ResetScrollPositionMixin, {
  session: Ember.inject.service('session'),
  setupController(controller, model) {
    // Call _super for default behavior
    this._super(controller, model);
    // Implement your custom setup after
    let invoice = this.get('store').createRecord('invoice', {
      impressions: model,
    });
    let reduceFirstImpressions = invoice.reduceFirstImpressions();
    invoice.initializeAmounts();
    Ember.RSVP.all(reduceFirstImpressions.map((s) => {
      //free some budget, first
      return s.save();
    })).then(() => {
      invoice.get('impressions').forEach((s) => {
        s.save();
      });
    });
    controller.set('invoice', invoice);
  },
  model() {
    return this.store.query('impression', {
      filter: {
        response: 'positive'
      }
    });
  },
});
