import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | visualize/calendar heatmap', function() {
  setupComponentTest('visualize/calendar-heatmap', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#visualize/calendar-heatmap}}
    //     template content
    //   {{/visualize/calendar-heatmap}}
    // `);

    this.render(hbs`{{visualize/calendar-heatmap}}`);
    expect(this.$()).to.have.length(1);
  });
});
