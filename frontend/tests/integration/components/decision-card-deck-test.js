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

  it('initially 9 visible broadcast', function() {
    this.set('someBroadcasts', makeList('broadcast', 23));
    this.render(hbs`{{decision-card-deck broadcasts=someBroadcasts}}`);
    let length = this.$('.decision-card').length;
    expect(length).to.eq(9);
  });

});
