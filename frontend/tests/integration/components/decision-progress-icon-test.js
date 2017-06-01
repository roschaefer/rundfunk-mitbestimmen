import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Integration | Component | decision progress icon', function() {
  setupComponentTest('decision-progress-icon', {
    integration: true
  });
  beforeEach(function(){
    manualSetup(this.container);
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });

    this.set('aBroadcast', make('broadcast'));
    this.render(hbs`{{decision-progress-icon broadcast=aBroadcast}}`);

    expect(this.$()).to.have.length(1);
    expect(this.$().text().trim()).to.eq('');

    // Template block usage:
    this.render(hbs`
    {{#decision-progress-icon broadcast=aBroadcast}}
      template block text
    {{/decision-progress-icon}}
  `);

    expect(this.$()).to.have.length(1);
    expect(this.$().text().trim()).to.eq('template block text');
  });
});
