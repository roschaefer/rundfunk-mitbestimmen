import Ember from 'ember';
import RSVP from 'rsvp';

export default Ember.Route.extend({
  model() {
    return RSVP.hash({
      tv: this.store.query('statistic/station', {
        filter: {
          medium_id: 0
        }
      }),
      radio: this.store.query('statistic/station', {
        filter: {
          medium_id: 1
        }
      }),
    });
  }
});
