import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | visualize/index', function() {
  setupTest('route:visualize/index', {
    needs: [
      'service:metrics',
      'ember-metrics@metrics-adapter:piwik'
    ]
  });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
