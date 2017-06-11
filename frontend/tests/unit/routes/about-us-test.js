import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | about us', function() {
  setupTest('route:about-us', {
    needs: [
      'service:metrics',
      'ember-metrics@metrics-adapter:piwik', // bundled adapter
    ]
  });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
