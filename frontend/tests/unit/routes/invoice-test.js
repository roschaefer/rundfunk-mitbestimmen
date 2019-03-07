import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | invoice', function() {
  setupTest('route:invoice', { integration: true });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
