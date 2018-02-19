import Service from '@ember/service';
import { expect } from 'chai';
import { context, beforeEach, describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';
import hbs from 'htmlbars-inline-precompile';

let broadcast, intl;
const sessionStub = Service.extend({
  isAuthenticated: true,
});

describe('Integration | Component | broadcast/broadcast details', function() {
  setupComponentTest('broadcast/broadcast-details', {
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

  it('renders', function() {
    this.render(hbs`{{broadcast/broadcast-details broadcast=broadcast}}`);
    expect(this.$()).to.have.length(1);
  });

  context('unauthenticated', function() {
    describe('click on edit button', function() {
      it('asks to login', function(done) {
        this.set('broadcast', broadcast);
        this.set('loginAction', function() {
          done();
        });
        this.render(hbs`{{broadcast/broadcast-details broadcast=broadcast loginAction=loginAction}}`);
        this.$('.edit.button').click();
      });
    });

    describe('click on support button', function() {
      it('asks to login', function(done){
        this.set('broadcast', broadcast);
        this.set('loginAction', function() {
          done();
        });
        this.render(hbs`{{broadcast/broadcast-details broadcast=broadcast loginAction=loginAction}}`);
        this.$('.decision-card-support-button').click();
      });
    });
  });

  context('authenticated', function() {
    beforeEach(function(){
      this.register('service:session', sessionStub);
      this.inject.service('session', { as: 'sessionService' });
    });

    describe('click on support button', function() {
      it('calls respondAction', function() {
        this.set('broadcast', broadcast);
        expect(broadcast.get('response')).to.be.undefined;
        this.render(hbs`{{broadcast/broadcast-details broadcast=broadcast}}`);
        this.$('.decision-card-support-button').click();
        expect(broadcast.get('response')).to.eq('positive');
      });
    });
  });
});
