import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default Route.extend({
  intl: service(),
  model() {
    return this.store.findAll('statistic/medium');
  },
  init(){
    this._super(...arguments);
    this.get('intl').addObserver('locale', () =>  {
      this.refresh();
    });
  },
});
