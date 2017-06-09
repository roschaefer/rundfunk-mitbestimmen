/* jshint expr: true */
import { expect } from 'chai';
import { context, beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

let step;

describe('Integration | Component | find broadcasts/navigation', function() {
  setupComponentTest('find-broadcasts/navigation', {
    integration: true
  });

  it('renders', function() {
    this.render(hbs`{{find-broadcasts/navigation}}`);
    expect(this.$()).to.have.length(1);
  });

  context('step=1', function() {
    beforeEach(function(){
      step = 1;
    });

    it('click on next calls browse action', function(done) {
      this.set('browse', (step) => {
        expect(step).to.eq(2);
        done();
      });
      this.set('step', step);
      this.render(hbs`{{find-broadcasts/navigation step=step totalSteps=10 browse=browse}}`);
      this.$('button.find-broadcasts-navigation-next').click();
    });

    it('back button is disabled', function(){
      this.set('step', step);
      this.render(hbs`{{find-broadcasts/navigation step=step totalSteps=10}}`);
      expect(this.$('button.find-broadcasts-navigation-back').hasClass('disabled')).to.be.true;
    });

  });

  context('step=2', function() {
    beforeEach(function(){
      step = 2;
    });

    it('back button is enabled', function(){
      this.set('step', step);
      this.render(hbs`{{find-broadcasts/navigation step=step totalSteps=10}}`);
      expect(this.$('button.find-broadcasts-navigation-back').hasClass('disabled')).to.be.false;
    });

    it('click on back calls browse action', function(done) {
      this.set('step', step);
      this.set('browse', (step) => {
        expect(step).to.eq(1);
        done();
      });
      this.set('step', step);
      this.render(hbs`{{find-broadcasts/navigation step=step totalSteps=10 browse=browse}}`);
      this.$('button.find-broadcasts-navigation-back').click();
    });

    context('step is at totalSteps', function(){
      it('next button is disabled', function(){
        this.set('step', step);
        this.render(hbs`{{find-broadcasts/navigation step=step totalSteps=1}}`);
        expect(this.$('button.find-broadcasts-navigation-next').hasClass('disabled')).to.be.true;
      });
    });
  });

  it('keeps track of all positive decisions');
  it('keeps track of all neutral decisions');
});
