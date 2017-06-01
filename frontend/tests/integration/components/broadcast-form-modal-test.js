import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | broadcast form modal', function() {
  setupComponentTest('broadcast-form-modal', {
    integration: true
  });

  it('renders', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');

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
