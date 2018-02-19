import { helper } from '@ember/component/helper';

export function broadcastSortButtonCss([button, sort]) {
  if (button === sort) {
    return 'ui active icon button';
  } else {
    return 'ui icon button';
  }
}

export default helper(broadcastSortButtonCss);
