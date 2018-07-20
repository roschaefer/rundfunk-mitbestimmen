import Component from '@ember/component';

export default Component.extend({
  didRender(){
    if (this.get('deeplinkedFaq') === this.get('key')){
      this.$('.ui.card').transition('tada', 1000);
    }
  }
});
