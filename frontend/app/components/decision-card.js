import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['decision-card ui card'],
  session: Ember.inject.service('session'),

  actions: {
    respond(response){
      if (this.get('session.isAuthenticated')) {
        this.get('broadcast').respond(response);
        if (this.get('respondAction')) {
          this.get('respondAction')(this.get('broadcast'));
        }
        this.rerender();
      } else {
        this.get('loginAction')();
      }

    }
  }
});
