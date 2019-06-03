import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | visualize/diff/media', function() {
  setupTest('route:visualize/diff/media', { integration: true });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
