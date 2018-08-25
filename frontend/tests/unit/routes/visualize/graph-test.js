import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Route | visualize/graph', function() {
  setupTest('route:visualize/graph', {
    needs: [
      'service:intl',
      'service:session',
      'service:metrics',
      'service:fastboot',
      'ember-metrics@metrics-adapter:piwik'
    ]
  });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
