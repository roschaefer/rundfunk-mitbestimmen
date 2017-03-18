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
      selections: model,
    });
    let reduceFirstSelections = invoice.reduceFirstSelections();
    invoice.initializeAmounts();
    Ember.RSVP.all(reduceFirstSelections.map((s) => {
      //free some budget, first
      return s.save();
    })).then(() => {
      invoice.get('selections').forEach((s) => {
        s.save();
      });
    });
    controller.set('invoice', invoice);
  },
  model() {
    return this.store.query('selection', {
      filter: {
        response: 'positive'
      }
    });
  },
});
