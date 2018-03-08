import Route from '@ember/routing/route';
import { task } from 'ember-concurrency';

export default Route.extend({
  model() {
    {
      return {
        statisticTaskInstance: this.get('statisticTask').perform()
      }
    }
  },
  statisticTask: task(function * () {
    return yield this.store.queryRecord('summarized-statistic', {});
  }),
});
