import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | faq', function() {
  setupTest('route:faq', {
    // Specify the other units that are required for this test.
    needs: ['service:metrics']
  });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
