import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

let intl;
describe('Unit | Route | visualize/graph', function() {
  setupTest('route:visualize/graph', {
    needs: [
      'service:intl',
      'service:session',
      'service:metrics',
      'service:fastboot',
      'ember-metrics@metrics-adapter:piwik',
      'config:environment',
      'cldr:en',
      'cldr:de',
      'ember-intl@adapter:default'
    ],
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });

  it('exists', function() {
    let route = this.subject();
    expect(route).to.be.ok;
  });
});
