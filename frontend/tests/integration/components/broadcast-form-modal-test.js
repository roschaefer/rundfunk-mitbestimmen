import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

let intl;
describe('Integration | Component | broadcast form modal', function() {
  setupComponentTest('broadcast-form-modal', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });

  it('renders', function() {
    this.render(hbs`{{broadcast-form-modal}}`);
    expect(this.$()).to.have.length(1);
    expect(this.$().text().trim()).to.match(/Edit broadcast/);

    // Template block usage:
    this.render(hbs`
    {{#broadcast-form-modal}}
      template block text
    {{/broadcast-form-modal}}
  `);

    expect(this.$().text()).to.match(/template block text/);
  });
});
