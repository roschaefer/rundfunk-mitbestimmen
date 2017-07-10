import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | missing feature/preview', function() {
  setupComponentTest('missing-feature/preview', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#missing-feature/preview}}
    //     template content
    //   {{/missing-feature/preview}}
    // `);

    this.render(hbs`{{missing-feature/preview}}`);
    expect(this.$()).to.have.length(1);
  });
});
