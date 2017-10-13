import { expect } from 'chai';
import { describe, it, context } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | language chooser', function() {
  setupComponentTest('language-chooser', {
    integration: true
  });

  context('locale en', function() {
    it('shows german flag', function() {
      this.inject.service('intl');
      this.container.lookup('service:intl').setLocale('en');
      this.render(hbs`{{language-chooser}}`);
      expect(this.$()).to.have.length(1);
      let text = this.$().text();
      expect(text).to.match(/Deutsch/);
    });
  });

  context('locale de', function() {
    it('shows english flag', function() {
      this.inject.service('intl');
      this.container.lookup('service:intl').setLocale('de');
      this.render(hbs`{{language-chooser}}`);
      expect(this.$()).to.have.length(1);
      let text = this.$().text();
      expect(text).to.match(/English/);
    });

    it('shows just one flag', function() {
      this.inject.service('intl');
      this.container.lookup('service:intl').setLocale('de');
      this.render(hbs`{{language-chooser}}`);
      expect(this.$('.language.item')).to.have.length(1);
    });
  });
});
