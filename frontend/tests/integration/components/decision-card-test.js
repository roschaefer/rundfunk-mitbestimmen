/* jshint expr: true */
import { expect } from 'chai';
import { context, beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { make, manualSetup } from 'ember-data-factory-guy';

let broadcast, selection;

describe('Integration | Component | decision card', function() {
  setupComponentTest('decision-card', {
    integration: true
  });
  beforeEach(function(){
    manualSetup(this.container);
    broadcast = make('broadcast', {
      title: 'This is the title'
    });
  });

  it('renders', function() {
    this.set('broadcast', broadcast);
    this.render(hbs`{{decision-card broadcast=broadcast}}`);
    expect(this.$()).to.have.length(1);
  });

  it('displays the title', function() {
    this.set('broadcast', broadcast);
    this.render(hbs`{{decision-card broadcast=broadcast}}`);
    expect(this.$('#title').text().trim()).to.eq('This is the title');
  });

  describe('click on support button', function() {
    it('renders a positive button', function() {
      this.set('broadcast', broadcast);
      this.render(hbs`{{decision-card broadcast=broadcast}}`);
      expect(this.$('.decision-card-support-button').hasClass('positive')).to.be.false;
      this.$('.decision-card-support-button').click();
      expect(this.$('.decision-card-support-button').hasClass('positive')).to.be.true;
    });

    it('displays positive support button', function() {
      this.set('broadcast', broadcast);
      this.render(hbs`{{decision-card broadcast=broadcast}}`);
      expect(this.$('.decision-card-support-button').hasClass('positive')).to.be.false;
      this.$('.decision-card-support-button').click();
      expect(this.$('.decision-card-support-button').hasClass('positive')).to.be.true;
    });

    context('broadcast is already supported', function() {
      beforeEach(function(){
        selection = make('selection', {
          broadcast: broadcast,
          response: 'positive'
        });
      });

      it('neutralizes the support button', function() {
        this.set('broadcast', broadcast);
        this.render(hbs`{{decision-card broadcast=broadcast}}`);
        expect(this.$('.decision-card-support-button').hasClass('positive')).to.be.true;
        this.$('.decision-card-support-button').click();
        expect(this.$('.decision-card-support-button').hasClass('positive')).to.be.false;
      });
    });
  });
});
