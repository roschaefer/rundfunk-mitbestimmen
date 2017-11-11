import Ember from 'ember';
import { expect } from 'chai';
import { context, beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { make, manualSetup } from 'ember-data-factory-guy';

let broadcast, intl;
const sessionStub = Ember.Service.extend({
  isAuthenticated: true,
});

describe('Integration | Component | decision card', function() {
  setupComponentTest('decision-card', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });

  beforeEach(function(){
    manualSetup(this.container);
    broadcast = make('broadcast', {
      title: 'This is the title'
    });
  });

  context('unauthenticated', function() {
    describe('click on support button', function() {
      it('calls the login action', function(done) {
        this.set('broadcast', broadcast);
        this.set('loginAction', function() {
          done();
        });
        this.render(hbs`{{decision-card broadcast=broadcast loginAction=loginAction}}`);
        this.$('.decision-card-support-button').click();
      });

      it('keeps the response to the broadcast unchanged', function() {
        this.set('broadcast', broadcast);
        this.set('loginAction', function() {});
        this.render(hbs`{{decision-card broadcast=broadcast loginAction=loginAction}}`);
        this.$('.decision-card-support-button').click();
        expect(broadcast.get('response')).to.be.undefined;
      });
    });
  });

  context('authenticated', function() {
    beforeEach(function(){
      this.register('service:session', sessionStub);
      this.inject.service('session', { as: 'sessionService' });
    });

    it('renders', function() {
      this.set('broadcast', broadcast);
      this.render(hbs`{{decision-card broadcast=broadcast}}`);
      expect(this.$()).to.have.length(1);
    });

    it('displays the title', function() {
      this.set('broadcast', broadcast);
      this.render(hbs`{{decision-card broadcast=broadcast}}`);
      expect(this.$('.title').text().trim()).to.eq('This is the title');
    });

    describe('click on support button', function() {
      it('turns the heart red', function() {
        this.set('broadcast', broadcast);
        this.render(hbs`{{decision-card broadcast=broadcast}}`);
        expect(this.$('.decision-card-support-button i.icon.heart').hasClass('red')).to.be.false;
        this.$('.decision-card-support-button').click();
        expect(this.$('.decision-card-support-button i.icon.heart').hasClass('red')).to.be.true;
      });

      it('saves the response on the broadcast', function() {
        this.set('broadcast', broadcast);
        this.render(hbs`{{decision-card broadcast=broadcast}}`);
        expect(broadcast.get('response')).to.be.undefined;
        this.$('.decision-card-support-button').click();
        expect(broadcast.get('response')).to.eq('positive');
      });

      it('calls respondAction and returns the broadcast, if respondAction given', function(done) {
        let broadcast = make('broadcast', {
          title: 'this title is to be expected'
        });
        this.set('broadcast', broadcast);
        this.set('callback', function(broadcast) {
          expect(broadcast.get('title')).to.eq('this title is to be expected');
          done();
        });
        this.render(hbs`{{decision-card broadcast=broadcast respondAction=callback}}`);
        this.$('.decision-card-support-button').click();
      });

      context('broadcast is already supported', function() {
        beforeEach(function(){
          make('impression', {
            broadcast: broadcast,
            response: 'positive'
          });
        });

        it('turns the heart grey', function() {
          this.set('broadcast', broadcast);
          this.render(hbs`{{decision-card broadcast=broadcast}}`);
          expect(this.$('.decision-card-support-button i.icon.heart').hasClass('red')).to.be.true;
          this.$('.decision-card-support-button').click();
          expect(this.$('.decision-card-support-button i.icon.heart').hasClass('red')).to.be.false;
        });

        it('toggles the response on the broadcast', function() {
          this.set('broadcast', broadcast);
          this.render(hbs`{{decision-card broadcast=broadcast}}`);
          expect(broadcast.get('response')).to.eq('positive');
          this.$('.decision-card-support-button').click();
          expect(broadcast.get('response')).to.eq('neutral');
        });
      });
    });
  });
});
