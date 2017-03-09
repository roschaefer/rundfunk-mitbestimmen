import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';


export default Ember.Route.extend(ResetScrollPositionMixin, {
  session: Ember.inject.service('session'),
  setupController(controller, model) {
    // Call _super for default behavior
    this._super(controller, model);
    // Implement your custom setup after
    let invoice = this.get('store').createRecord('invoice', {
      selections: model,
    });
    if (this.get('session').get('isAuthenticated')) {
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
    }
    controller.set('invoice', invoice);
  },
  model() {
    if (this.get('session').get('isAuthenticated')) {
      return this.store.query('selection', {
        filter: {
          response: 'positive'
        }
      });
    } else  {
      let selections = this.store.peekAll('selection');
      return selections.filter((s) => {
        return s.get('response') === 'positive';
      });
    }
  },
});
