import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    back(){
      history.back();
    },
  }
});
