import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | language chooser', function() {
  setupComponentTest('language-chooser', {
    integration: true
  });

  it('renders', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');
    this.render(hbs`{{language-chooser}}`);
    expect(this.$()).to.have.length(1);
    let text = this.$().text();
    expect(text).to.match(/Englisch/);
    expect(text).to.match(/Deutsch/);
  });
});
