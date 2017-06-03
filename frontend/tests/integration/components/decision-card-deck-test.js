/* jshint expr: true */
import { expect } from 'chai';
import { context, beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { makeList, manualSetup } from 'ember-data-factory-guy';

describe('Integration | Component | decision card deck', function() {
  let step;
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

  context('step=0', function() {
    beforeEach(function(){
      step = 0;
    });

    it('click on next calls browse action', function(done) {
      this.set('browse', (step) => {
        expect(step).to.eq(1);
        done();
      });
      this.set('someBroadcasts', makeList('broadcast', 9));
      this.render(hbs`{{decision-card-deck broadcasts=someBroadcasts browse=browse step=step}}`);
      this.$('button.decision-card-deck-next').click();
    });

    it('back button is disabled', function(){
      this.set('step', step);
      this.set('someBroadcasts', makeList('broadcast', 9));
      this.render(hbs`{{decision-card-deck step=step broadcasts=someBroadcasts}}`);
      console.log(this.$('button.decision-card-deck-back'));
      expect(this.$('button.decision-card-deck-back').hasClass('disabled')).to.be.true;
    });

    context('less results than space', function(){
      it('next button is disabled', function(){
        this.set('someBroadcasts', makeList('broadcast', 2));
        this.render(hbs`{{decision-card-deck step=step broadcasts=someBroadcasts}}`);
        expect(this.$('button.decision-card-deck-next').hasClass('disabled')).to.be.true;
      });
    });
  });

  context('step=1', function() {
    beforeEach(function(){
      step = 1;
    });

    it('back button is enabled', function(){
      this.set('step', step);
      this.set('someBroadcasts', makeList('broadcast', 9));
      this.render(hbs`{{decision-card-deck step=step broadcasts=someBroadcasts}}`);
      console.log(this.$('button.decision-card-deck-back'));
      expect(this.$('button.decision-card-deck-back').hasClass('disabled')).to.be.false;
    });

    it('click on back calls browse action', function(done) {
      this.set('step', step);
      this.set('browse', (step) => {
        expect(step).to.eq(0);
        done();
      });
      this.set('step', step);
      this.set('someBroadcasts', makeList('broadcast', 9));
      this.render(hbs`{{decision-card-deck broadcasts=someBroadcasts step=step browse=browse}}`);
      this.$('button.decision-card-deck-back').click();
    });
  });

  it('keeps track of all positive decisions');
  it('keeps track of all neutral decisions');
  it('asks the user to distribute budget at some point');

});
