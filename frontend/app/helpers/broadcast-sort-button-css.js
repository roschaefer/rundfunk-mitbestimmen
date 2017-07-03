import Ember from 'ember';

export function broadcastSortButtonCss([button, sort]) {
  if (button === sort) {
    return 'ui active icon button';
  } else {
    return 'ui icon button';
  }
}

export default Ember.Helper.helper(broadcastSortButtonCss);
