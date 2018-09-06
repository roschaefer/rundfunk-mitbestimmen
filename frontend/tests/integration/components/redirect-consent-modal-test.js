import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | redirect-consent-modal', function() {
  setupComponentTest('redirect-consent-modal', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#redirect-consent-modal}}
    //     template content
    //   {{/redirect-consent-modal}}
    // `);

    this.render(hbs`{{redirect-consent-modal}}`);
    expect(this.$()).to.have.length(1);
  });
});
