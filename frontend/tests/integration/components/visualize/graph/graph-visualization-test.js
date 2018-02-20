import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | visualize/graph/graph-visualization', function() {
  setupComponentTest('visualize/graph/graph-visualization', {
    integration: true
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#visualize/graph/graph-visualization}}
    //     template content
    //   {{/visualize/graph/graph-visualization}}
    // `);

    this.render(hbs`{{visualize/graph/graph-visualization}}`);
    expect(this.$()).to.have.length(1);
  });
});
