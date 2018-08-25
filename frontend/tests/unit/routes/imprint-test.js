import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | imprint', function() {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
  setupTest('route:imprint', {
    needs: [
      'service:metrics',
      'service:fastboot',
      'ember-metrics@metrics-adapter:piwik', // bundled adapter
    ]
  });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
