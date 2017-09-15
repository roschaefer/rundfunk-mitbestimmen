import Ember from 'ember';
import RSVP from 'rsvp';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  setupController(controller, model) {
    controller.set('broadcast', this.modelFor('broadcast'));
    this._super(controller, model);
  },
  model() {
    return RSVP.hash({
      media: this.get('store').findAll('medium'),
      stations: this.get('store').findAll('station')
    });
  },
});
