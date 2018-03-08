import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | loading spinner', function() {
  setupComponentTest('loading-spinner', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#loading-spinner}}
    //     template content
    //   {{/loading-spinner}}
    // `);

    this.render(hbs`{{loading-spinner}}`);
    expect(this.$()).to.have.length(1);
  });
});
