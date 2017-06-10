import { expect } from 'chai';
import { context, beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';

let step, recentPositives;

describe('Integration | Component | find broadcasts/navigation', function() {
  setupComponentTest('find-broadcasts/navigation', {
    integration: true
  });

  it('renders', function() {
    this.render(hbs`{{find-broadcasts/navigation}}`);
    expect(this.$()).to.have.length(1);
  });

  describe('recent supported broadcasts', function() {
    context('recentPositives = 0', function() {
      beforeEach(function(){
        recentPositives = 0;
      });

      it('shows grey heart', function() {
        this.set('recentPositives', recentPositives);
        this.render(hbs`{{find-broadcasts/navigation step=1 totalSteps=10 browse=browse recentPositives=recentPositives}}`);
        expect(this.$('.heart.icon').hasClass('grey')).to.be.true;
      });

      it('unable to distribute the budget', function() {
        this.set('recentPositives', recentPositives);
        this.render(hbs`{{find-broadcasts/navigation step=1 totalSteps=10 browse=browse recentPositives=recentPositives}}`);
        expect(this.$('.find-broadcasts-navigation-distribute-button').hasClass('disabled')).to.be.true;
      });
    });

    context('recentPositives = 1', function() {
      beforeEach(function(){
        recentPositives = 1;
      });

      it('does not suggest to distribute the budget', function() {
        this.set('recentPositives', recentPositives);
        this.render(hbs`{{find-broadcasts/navigation step=1 totalSteps=10 browse=browse recentPositives=recentPositives}}`);
        expect(this.$('.find-broadcasts-navigation-distribute-button').hasClass('disabled')).to.be.false;
        expect(this.$('.find-broadcasts-navigation-distribute-button').hasClass('primary')).to.be.false;
      });

      it('shows red heart', function() {
        this.set('recentPositives', recentPositives);
        this.render(hbs`{{find-broadcasts/navigation step=1 totalSteps=10 browse=browse recentPositives=recentPositives}}`);
        expect(this.$('.heart.icon').hasClass('red')).to.be.true;
      });
    });

    context('recentPositives = 3', function() {
      beforeEach(function(){
        recentPositives = 3;
      });

      it('shows red heart', function() {
        this.set('recentPositives', recentPositives);
        this.render(hbs`{{find-broadcasts/navigation step=1 totalSteps=10 browse=browse recentPositives=recentPositives}}`);
        expect(this.$('.heart.icon').hasClass('red')).to.be.true;
      });

      it('suggests to distribute the budget', function() {
        this.set('recentPositives', recentPositives);
        this.render(hbs`{{find-broadcasts/navigation step=1 totalSteps=10 browse=browse recentPositives=recentPositives}}`);
        expect(this.$('.find-broadcasts-navigation-distribute-button').hasClass('primary')).to.be.true;
      });
    });
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
});
