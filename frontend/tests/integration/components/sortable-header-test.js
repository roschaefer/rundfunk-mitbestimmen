import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | sortable header', function() {
  setupComponentTest('sortable-header', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#sortable-header}}
    //     template content
    //   {{/sortable-header}}
    // `);

    this.render(hbs`{{sortable-header}}`);
    expect(this.$()).to.have.length(1);
  });
});
