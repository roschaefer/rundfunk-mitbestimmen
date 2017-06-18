import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | missing feature', function() {
  setupComponentTest('missing-feature', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#missing-feature}}
    //     template content
    //   {{/missing-feature}}
    // `);

    this.render(hbs`{{missing-feature}}`);
    expect(this.$()).to.have.length(1);
  });
});
