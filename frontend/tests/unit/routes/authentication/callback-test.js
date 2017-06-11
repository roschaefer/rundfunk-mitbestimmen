import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | authentication/callback', function() {
  setupTest('route:authentication/callback', {
    needs: [
      'service:session',
      'service:metrics',
      'ember-metrics@metrics-adapter:piwik', // bundled adapter
    ]
  });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
