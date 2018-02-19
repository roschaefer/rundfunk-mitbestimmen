import RSVP from 'rsvp';
import Route from '@ember/routing/route';

export default Route.extend({
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
