import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

describe('Integration | Component | visualize/bubble chart', function() {
  setupComponentTest('visualize/bubble-chart', {
    integration: true
  });

  it('renders chartData', function() {
    this.set('chartData', []);
    this.on('clickCallback', function() {
    });

    this.render(hbs`{{visualize/bubble-chart chartData=chartData onClick=clickCallback}}`);
    expect(this.$()).to.have.length(1);
  });

  it('renders chartData', function() {
    this.set('chartData', [
      Object.create({
        id: 1,
        color: 'tan',
        label: 'title',
        tooltip: 'tooltip',
        size: 3,
      })
    ]);
    this.on('clickCallback', function() {
    });

    this.render(hbs`{{visualize/bubble-chart chartData=chartData onClick=clickCallback}}`);
    expect(this.$()).to.have.length(1);
  });
});
