import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | invoice footer', function() {
  setupComponentTest('invoice-footer', {
    integration: true
  });

  it('renders', function() {
    this.set('remaining', 5.0);
    this.set('total', 10.0);
    this.render(hbs`{{invoice-footer total=total remaining=remaining}}`);
    expect(this.$()).to.have.length(1);
  });

  it('formats the currencies', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');
    this.set('remaining', 5.0);
    this.set('total', 10.0);
    this.render(hbs`{{invoice-footer total=total remaining=remaining}}`);

    let text = this.$().text();
    expect(text).to.match(/€5.00/);
    expect(text).to.match(/€10.00/);
  });
});
