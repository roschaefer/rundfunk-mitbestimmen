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
    this.set('amount', 5.0);
    this.render(hbs`{{invoice-item-amount amount=amount}}`);

    let text = this.$().text();
    expect(text).to.match(/€5.00/);
  });

});
