import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Controller | broadcast/index', function() {
  setupTest('controller:broadcast/index', {
    // Specify the other units that are required for this test.
    // needs: ['controller:foo']
    needs: [
      'service:metrics',
      'service:session',
      'service:intl',
      'ember-metrics@metrics-adapter:piwik', // bundled adapter
    ]
  });

  // Replace this with your real tests.
  it('exists', function() {
    let controller = this.subject();
    expect(controller).to.be.ok;
  });
});
