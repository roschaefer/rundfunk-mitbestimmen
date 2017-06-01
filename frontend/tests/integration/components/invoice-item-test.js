import Ember from 'ember';
import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | invoice item', function() {
  setupComponentTest('invoice-item', {
    integration: true
  });

  it('renders', function() {
    let selection = Ember.Object.create({
      amount: 9.99,
      broadcast: {
        title: "Whatever",
      }
    });
    this.set('selection', selection);
    this.on('removeItem', function(selection) { return selection; });

    this.render(hbs`{{invoice-item selection=selection removeAction=(action 'removeItem')}}`);
    expect(this.$()).to.have.length(1);

    let text = this.$().text();
    expect(text).to.match(/Whatever/);

  });
});
