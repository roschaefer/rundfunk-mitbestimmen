/* jshint expr: true */
import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { makeList, manualSetup } from 'ember-data-factory-guy';

describe('Integration | Component | decision card deck', function() {
  setupComponentTest('decision-card-deck', {
    integration: true
  });
  beforeEach(function(){
    manualSetup(this.container);
  });

  it('renders', function() {
    this.set('someBroadcasts', makeList('broadcast', 3));
    this.render(hbs`{{decision-card-deck broadcasts=someBroadcasts}}`);
    expect(this.$()).to.have.length(1);
  });


});
