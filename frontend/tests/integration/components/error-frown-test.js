import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

let intl;
describe('Integration | Component | error frown', function() {
  setupComponentTest('error-frown', {
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
    //   {{#error-frown}}
    //     template content
    //   {{/error-frown}}
    // `);

    this.render(hbs`{{error-frown}}`);
    expect(this.$()).to.have.length(1);
  });
});
