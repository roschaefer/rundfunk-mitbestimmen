import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | dynamic high charts', function() {
  setupComponentTest('dynamic-high-charts', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#dynamic-high-charts}}
    //     template content
    //   {{/dynamic-high-charts}}
    // `);

    this.render(hbs`{{dynamic-high-charts}}`);
    expect(this.$()).to.have.length(1);
  });

  it('calls afterRendered', function(done) {
    this.set('notify', function() {
      done();
    });
    this.render(hbs`{{dynamic-high-charts afterRendered=notify}}`);
  });

});
