import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | table spinner', function() {
  setupComponentTest('table-spinner', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#table-spinner}}
    //     template content
    //   {{/table-spinner}}
    // `);

    this.render(hbs`{{table-spinner}}`);
    expect(this.$()).to.have.length(1);
  });
});
