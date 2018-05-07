import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Controller | visualize/demography', function() {
  setupTest('controller:visualize/demography', {
<<<<<<< HEAD
    needs: [
      'service:metrics',
      'service:session',
      'ember-metrics@metrics-adapter:piwik', // bundled adapter
    ]
=======
    // Specify the other units that are required for this test.
    // needs: ['controller:foo']
>>>>>>> master
  });

  // Replace this with your real tests.
  it('exists', function() {
    let controller = this.subject();
    expect(controller).to.be.ok;
  });
});
