import Component from '@ember/component';
import { computed } from '@ember/object';
import { isNone } from '@ember/utils';

export default Component.extend({
  displayedState: computed('state', function() {
    return this.get('state') || 'Germany';
  }),
  displayedNumber: computed('count', function() {
    if (isNone(this.get('count'))) {
      return this.get('totalGermanUsers');
    } else {
      return this.get('count');
    }
  }),
  displayedPercentage: computed('count', function() {
    if (isNone(this.get('count'))) {
      return `${((this.get('totalGermanUsers')/this.get('totalUsers')) * 100).toFixed(2)}`;
    } else {
      return `${((this.get('count')/this.get('totalGermanUsers')) * 100).toFixed(2)}`;
    }
  }),
  displayedPercentageTranslation: computed('count', function() {
    if (isNone(this.get('count'))){
        return 'visualize.geo.info-box.of-the-world';
    } else {
        return 'visualize.geo.info-box.of-germany';
    }
  })
});
