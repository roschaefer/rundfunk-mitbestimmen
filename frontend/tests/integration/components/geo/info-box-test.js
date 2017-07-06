import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | geo/info box', function() {
  setupComponentTest('geo/info-box', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#geo/info-box}}
    //     template content
    //   {{/geo/info-box}}
    // `);

    this.render(hbs`{{geo/info-box}}`);
    expect(this.$()).to.have.length(1);
  });
});
