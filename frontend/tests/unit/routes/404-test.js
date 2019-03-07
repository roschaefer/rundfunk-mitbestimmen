import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | 404', function() {
  setupTest('route:404', { integration: true });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
