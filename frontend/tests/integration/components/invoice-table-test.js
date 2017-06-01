import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | invoice table', function() {
  setupComponentTest('invoice-table', {
    integration: true
  });

  it('renders', function() {
    let invoiceStub = {
      total: function() {
        return 11.0;
      },
      leftOver: function() {
        return 6.5;
      }
    };
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');

    this.set('invoice', invoiceStub);
    this.render(hbs`{{invoice-table invoice=invoice}}`);
    expect(this.$()).to.have.length(1);
    let text = this.$().text();
    expect(text).to.match(/Title/);
    expect(text).to.match(/Amount/);
    expect(text).to.match(/Budget/);
  });
});
