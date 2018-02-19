import { inject as service } from '@ember/service';
import { all } from 'rsvp';
import Route from '@ember/routing/route';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';


export default Route.extend(AuthenticatedRouteMixin, ResetScrollPositionMixin, {
  session: service(),
  setupController(controller, model) {
    // Call _super for default behavior
    this._super(controller, model);
    // Implement your custom setup after
    let invoice = this.get('store').createRecord('invoice', {
      impressions: model,
    });
    let reduceFirstImpressions = invoice.reduceFirstImpressions();
    invoice.initializeAmounts();
    all(reduceFirstImpressions.map((s) => {
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
