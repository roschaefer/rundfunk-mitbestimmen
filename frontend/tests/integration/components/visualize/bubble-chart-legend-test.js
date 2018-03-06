import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | visualize/bubble chart legend', function() {
  setupComponentTest('visualize/bubble-chart-legend', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#visualize/bubble-chart-legend}}
    //     template content
    //   {{/visualize/bubble-chart-legend}}
    // `);

    this.render(hbs`{{visualize/bubble-chart-legend}}`);
    expect(this.$()).to.have.length(1);
  });
});
