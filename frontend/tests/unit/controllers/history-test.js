import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Controller | history', function() {
  setupTest('controller:history', {
    // Specify the other units that are required for this test.
    needs: [
      'service:metrics',
      'service:session',
      'ember-metrics@metrics-adapter:piwik', // bundled adapter
    ]
  });

  // Replace this with your real tests.
  it('exists', function() {
    let controller = this.subject();
    expect(controller).to.be.ok;
  });
});
