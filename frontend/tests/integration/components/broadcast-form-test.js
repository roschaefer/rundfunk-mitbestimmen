import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | broadcast form', function() {
  setupComponentTest('broadcast-form', {
    integration: true
  });

  it('renders title and description', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');

    this.render(hbs`{{broadcast-form}}`);
    expect(this.$().text()).to.match(/Title/);
    expect(this.$().text()).to.match(/Description/);

    this.render(hbs`
       {{#broadcast-form}}
         template block text
       {{/broadcast-form}}
     `);
    expect(this.$().text()).to.match(/template block text/);
  });
});
