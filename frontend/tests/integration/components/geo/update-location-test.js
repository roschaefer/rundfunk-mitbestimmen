import Service from '@ember/service';
import { run } from '@ember/runloop';
import wait from 'ember-test-helpers/wait';
import { expect, assert } from 'chai';
import { describe, it, context, beforeEach } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import { build, make, manualSetup } from 'ember-data-factory-guy';
import hbs from 'htmlbars-inline-precompile';

let user;
const sessionStub = Service.extend({
  isAuthenticated: true,
});
let intl;

describe('Integration | Component | geo/update location', function() {
  setupComponentTest('geo/update-location', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });
  beforeEach(function(){
    manualSetup(this.container);
    this.register('service:session', sessionStub);
    this.inject.service('session', { as: 'sessionService' });
  });

  it('renders', function() {
    this.render(hbs`{{geo/update-location}}`);
    expect(this.$()).to.have.length(1);
  });

  describe('isUpdatingLocation', function() {
    it('asks the user to click on the map', function(){
      this.render(hbs`{{geo/update-location isUpdatingLocation=true}}`);
      return wait().then(() => {
        expect(this.$().text()).to.include('Click on the map');
      });
    })
  })

  describe('click', function() {
    describe('not logged in', function() {
      beforeEach(function(){
        this.set('sessionService.isAuthenticated', false);
      });

      it('calls the login action', function(done) {
        user = build('user');
        this.set('user', user);
        this.set('startUpdateLocation', () => { assert.fail()});
        this.set('loginAction', () => { done() });
        this.render(hbs`{{
        geo/update-location
        user=user
        startUpdateLocationAction=startUpdateLocation
        loginAction=loginAction
        }}`);
        run(() => document.querySelector('button').click());
      });
    });

    describe('logged in', function() {
      beforeEach(function(){
        this.set('sessionService.isAuthenticated', true);
      });

      it('calls the login action', function(done) {
        user = build('user');
        this.set('user', user);
        this.set('loginAction', ()=> { assert.fail()});
        this.set('startUpdateLocation', () => { done() });
        this.render(hbs`{{
        geo/update-location
        user=user
        startUpdateLocationAction=startUpdateLocation
        loginAction=loginAction
        }}`);
        run(() => document.querySelector('button').click());
      });

      it('asks to add a location', function() {
        user = build('user');
        this.set('user', user);
        this.render(hbs`{{ geo/update-location user=user }}`);
        expect(this.$('button').text()).to.include('Add location');
      });

      context('user has a location already', function() {
        it('asks to update a location', function() {
          user = make('user', {
            latitude: 47,
            longitude: 11
          });
          this.set('user', user);
          this.render(hbs`{{ geo/update-location user=user }}`);
          expect(this.$('button').text()).to.include('Update location');
        });
      });
    });
  });
});
