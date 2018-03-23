import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

let intl;
describe('Integration | Component | missing feature/explanation', function() {
  setupComponentTest('missing-feature/explanation', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#missing-feature/explanation}}
    //     template content
    //   {{/missing-feature/explanation}}
    // `);

    this.render(hbs`{{missing-feature/explanation}}`);
    expect(this.$()).to.have.length(1);
  });
});
