import Ember from 'ember';
import UiModal from 'semantic-ui-ember/components/ui-modal';

export default UiModal.extend({
  name: 'signup-modal',
  classNames: [ 'signup-modal' ],
  session: Ember.inject.service('session'),
  didRender() {
    this._super(...arguments);
    if (this.get('session').get('isAuthenticated') === false){
      if (window._paq){
        window._paq.push(['trackGoal', 5]);
        //goalId 5 is "Show signup modal again"
      }

      this.$().modal('show');
    }
  },
  actions: {
    ok() {
      this.$().modal('hide');
      this.get('onConfirm')();
    }
  }
});
