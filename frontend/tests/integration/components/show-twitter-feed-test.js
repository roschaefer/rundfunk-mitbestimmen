import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | show-twitter-feed', function() {
  setupComponentTest('show-twitter-feed', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#show-twitter-feed}}
    //     template content
    //   {{/show-twitter-feed}}
    // `);

    this.render(hbs`{{show-twitter-feed}}`);
    expect(this.$()).to.have.length(1);
  });
});
