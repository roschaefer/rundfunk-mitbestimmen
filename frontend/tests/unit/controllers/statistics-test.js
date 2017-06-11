import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Controller | statistics', function() {
  setupTest('controller:statistics', {
    needs: [
      'service:session',
      'service:metrics',
      'ember-metrics@metrics-adapter:piwik', // bundled adapter
    ]
  });

  // Replace this with your real tests.
  it('it exists', function() {
    let controller = this.subject();
    expect(controller).to.be.ok;
  });
});
