import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | broadcast sort', function() {
  setupComponentTest('broadcast-sort', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#broadcast-sort}}
    //     template content
    //   {{/broadcast-sort}}
    // `);

    this.render(hbs`{{broadcast-sort}}`);
    expect(this.$()).to.have.length(1);
  });
});
