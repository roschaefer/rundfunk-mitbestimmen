import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import chroma from 'chroma-js';
import hbs from 'htmlbars-inline-precompile';

let intl;
describe('Integration | Component | visualize/bubble chart legend', function() {
  setupComponentTest('visualize/bubble-chart-legend', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });

  it('renders', function() {
    this.set('nullColor', chroma('tan'));
    this.set('missingDataLabel', 'no data');
    this.set('colorScale', chroma.scale(["deeppink", "lightblue", "limegreen"]).domain([-1.0, 0, 1.0]));

    this.render(hbs`{{visualize/bubble-chart-legend colorScale=colorScale staticColor=nullColor staticLabel=missingDataLabel}}`);

    expect(this.$()).to.have.length(1);
  });
});
