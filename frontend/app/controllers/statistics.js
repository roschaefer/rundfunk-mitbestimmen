import Controller from '@ember/controller';
import { inject as service} from '@ember/service';
import { alias } from '@ember/object/computed';

export default Controller.extend({
  session: service(),
  queryParams: ["page", "perPage", "column", "direction"],
  column: 'total',
  direction: 'desc',

  totalPages: alias("model.totalPages"),
  page: 1,
  perPage: 10,
  actions: {
    pageClicked(page) {
      this.set('page', page);
    },
    order(column){
      if (this.get('column') === column){
        if(this.get('direction') === 'desc'){
          this.set('direction', 'asc');
        } else{
          this.set('direction', 'desc');
        }
      }
      this.set('column', column);
    }
  }
});
