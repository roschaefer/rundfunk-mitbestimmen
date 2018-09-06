import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  classNames: ['decision-card ui card'],
  session: service('session'),
  actions: {
    respond(response){
      this.get('broadcast').respond(response);
      if (this.get('respondAction')) {
        this.get('respondAction')(this.get('broadcast'));
      }
      this.rerender();
    },
    openModal: function () {
      $('.ui.basic.modal').modal('show');
    }
  }
});
