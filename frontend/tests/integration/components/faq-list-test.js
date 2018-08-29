import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | faq list', function() {
  setupComponentTest('faq-list', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#faq-list}}
    //     template content
    //   {{/faq-list}}
    // `);

    this.render(hbs`{{faq-list}}`);
    expect(this.$()).to.have.length(1);
  });
});
