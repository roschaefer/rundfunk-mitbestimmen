import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | invoice', function() {
  setupTest('route:invoice', {
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
