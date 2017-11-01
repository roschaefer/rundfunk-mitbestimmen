import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | find broadcasts/navigation/distribute budget', function() {
  setupComponentTest('find-broadcasts/navigation/distribute-budget', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#find-broadcasts/navigation/distribute-budget}}
    //     template content
    //   {{/find-broadcasts/navigation/distribute-budget}}
    // `);

    this.render(hbs`{{find-broadcasts/navigation/distribute-budget}}`);
    expect(this.$()).to.have.length(1);
  });
});
