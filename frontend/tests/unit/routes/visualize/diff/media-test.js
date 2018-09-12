import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

let intl;
describe('Unit | Route | visualize/diff/media', function() {
  setupTest('route:visualize/diff/media', {
    needs: [
      'service:metrics',
      'service:fastboot',
      'service:intl',
      'ember-metrics@metrics-adapter:piwik', // bundled adapter
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
