import { expect } from 'chai';
import { describe, it } from 'mocha';
import { broadcastSortButtonCss } from 'frontend/helpers/broadcast-sort-button-css';

describe('Unit | Helper | broadcast sort button css', function() {
  // Replace this with your real tests.
  it('works', function() {
    let result = broadcastSortButtonCss(['asc', 'asc']);
    expect(result).to.eq('ui active icon button');
  });
});

