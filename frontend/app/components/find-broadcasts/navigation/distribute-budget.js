import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({
  tagName: '',

  buttonCss: computed('recentPositives', function() {
    switch(this.get('recentPositives')) {
      case 0: return 'disabled';
      case 1: return 'large';
      case 2: return 'big';
      default: return 'big primary';
    }
  }),
});
