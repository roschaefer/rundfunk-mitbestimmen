import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Integration | Component | decision card', function() {
  setupComponentTest('decision-card', {
    integration: true
  });
  beforeEach(function(){
    manualSetup(this.container);
  });

  it('renders', function() {
    this.set('aBroadcast', make('broadcast'));
    this.render(hbs`{{decision-card decide=true broadcast=aBroadcast}}`);
    expect(this.$()).to.have.length(1);
  });

  it('shows display button if it has a decide action', function() {
    this.inject.service('intl');
    this.container.lookup('service:intl').setLocale('en');

    this.set('aBroadcast', make('broadcast'));
    this.render(hbs`{{decision-card decide=true broadcast=aBroadcast}}`);

    let text = this.$().text();
    expect(text).to.match(/Support/);
    expect(text).to.match(/Next/);
  });
});
