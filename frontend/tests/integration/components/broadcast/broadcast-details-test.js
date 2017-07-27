import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | broadcast/broadcast details', function() {
  setupComponentTest('broadcast/broadcast-details', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#broadcast/broadcast-details}}
    //     template content
    //   {{/broadcast/broadcast-details}}
    // `);

    this.render(hbs`{{broadcast/broadcast-details}}`);
    expect(this.$()).to.have.length(1);
  });
});
