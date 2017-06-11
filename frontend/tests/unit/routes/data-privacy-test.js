import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | data privacy', function() {
  setupTest('route:data-privacy', {
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
