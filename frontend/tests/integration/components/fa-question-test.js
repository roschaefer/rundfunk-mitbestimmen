import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

let intl;
describe('Integration | Component | fa question', function() {
  setupComponentTest('fa-question', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });

  it('renders', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');

    this.render(hbs`{{fa-question key='finances'}}`);
    expect(this.$()).to.have.length(1);

    let text = this.$().text().trim();
    expect(text).to.match(/Who is financing this\?/);
    expect(text).to.match(/We ourselves/);

    // Template block usage:
    this.render(hbs`
    {{#fa-question key='finances'}}
      template block text
    {{/fa-question}}
  `);

    text = this.$().text().trim();
    expect(text).to.match(/template block text/);
  });
});
