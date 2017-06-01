import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | invoice item amount', function() {
  setupComponentTest('invoice-item-amount', {
    integration: true
  });

  it('renders', function() {
    this.set('amount', 5.0);
    this.render(hbs`{{invoice-item-amount amount=amount}}`);
    expect(this.$()).to.have.length(1);
  });

  it('renders currencies', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');
    this.set('amount', 5.0);
    this.render(hbs`{{invoice-item-amount amount=amount}}`);

    let text = this.$().text();
    expect(text).to.match(/€5.00/);
  });


  it('sanitizes input for changeAmountAction', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');
    this.set('checkSanitized', (amount) => {
      expect(amount).to.eq(7.0);
    });
    this.set('amount', 5.0);
    this.render(hbs`{{invoice-item-amount amount=amount changeAmountAction=(action checkSanitized)}}`);

    this.$('.ember-inline-edit').click();
    this.$('.ember-inline-edit-input').val('€7.0');
    this.$('.ember-inline-edit-input').trigger('input');
    this.$('.ember-inline-edit-save').click();
  });


  it('commas and dots are treated the same', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');
    this.set('checkSanitized', (amount) => {
      expect(amount).to.eq(7.0);
    });
    this.set('amount', 5.0);
    this.render(hbs`{{invoice-item-amount amount=amount changeAmountAction=(action checkSanitized)}}`);

    this.$('.ember-inline-edit').click();
    this.$('.ember-inline-edit-input').val('€7,0');
    this.$('.ember-inline-edit-input').trigger('input');
    this.$('.ember-inline-edit-save').click();
  });
});
