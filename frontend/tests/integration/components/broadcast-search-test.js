import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { makeList, manualSetup } from 'ember-data-factory-guy';

describe('Integration | Component | broadcast search', function() {
  setupComponentTest('broadcast-search', {
    integration: true
  });
  beforeEach(function(){
    manualSetup(this.container);
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');

    this.set('totalCount', 10);
    this.set('filterParams', {
      get(){
        return 'primary';
      }
    });
    this.set('stations', makeList('station', 3));
    this.set('media', makeList('medium', 2));
    this.render(hbs`{{broadcast-search totalCount=totalCount stations=stations media=media filterParams=filterParams}}`);
    expect(this.$()).to.have.length(1);

    let text = this.$().text();
    expect(text).to.match(/10\s+results/);

    // Template block usage:
    this.render(hbs`
    {{#broadcast-search stations=stations media=media filterParams=filterParams}}
      template block text
    {{/broadcast-search}}
  `);

    text = this.$().text();
    expect(this.$().text()).to.match(/template block text/);
  });
});
