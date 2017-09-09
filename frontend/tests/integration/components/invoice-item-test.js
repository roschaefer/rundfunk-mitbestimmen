import Ember from 'ember';
import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

let intl;
describe('Integration | Component | invoice item', function() {
  setupComponentTest('invoice-item', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });

  it('renders', function() {
    let impression = Ember.Object.create({
      amount: 9.99,
      broadcast: {
        title: "Whatever",
      }
    });
    this.set('impression', impression);
    this.on('removeItem', function(impression) { return impression; });

    this.render(hbs`{{invoice-item impression=impression removeAction=(action 'removeItem')}}`);
    expect(this.$()).to.have.length(1);

    let text = this.$().text();
    expect(text).to.match(/Whatever/);

  });
});
