import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Controller | statistics', function() {
  setupTest('controller:statistics', { integration: true });

  // Replace this with your real tests.
  it('it exists', function() {
    let controller = this.subject();
    expect(controller).to.be.ok;
  });
});
