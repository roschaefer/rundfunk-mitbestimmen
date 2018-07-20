import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | faq/faq card', function() {
  setupComponentTest('faq/faq-card', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#faq/faq-card}}
    //     template content
    //   {{/faq/faq-card}}
    // `);

    this.render(hbs`{{faq/faq-card}}`);
    expect(this.$()).to.have.length(1);
  });
});
