import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | help message', function() {
  setupComponentTest('help-message', {
    integration: true
  });

  it('renders', function() {
    this.render(hbs`{{help-message}}`);
    expect(this.$()).to.have.length(1);
  });
});
