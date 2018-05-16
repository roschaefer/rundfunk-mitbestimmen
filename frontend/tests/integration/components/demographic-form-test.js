import { expect } from 'chai';
import { describe, it, context, beforeEach } from 'mocha';
import { setupComponentTest } from 'ember-mocha';
import hbs from 'htmlbars-inline-precompile';
import { manualSetup, make } from 'ember-data-factory-guy';

let intl;
let currentUser;

describe('Integration | Component | demographic form', function() {

  setupComponentTest('demographic-form', {
    integration: true,
    setup() {
      intl = this.container.lookup('service:intl');
      intl.setLocale('en');
    }
  });

  it('renders', function() {
    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });
    // Template block usage:
    // this.render(hbs`
    //   {{#demographic-form}}
    //     template content
    //   {{/demographic-form}}
    // `);

    this.render(hbs`{{demographic-form}}`);
    expect(this.$()).to.have.length(1);
  });

  context('given the user is logged out', function() {
    beforeEach(function(){
      manualSetup(this.container);
      currentUser = null;
    });

    it('asks the user to login', function() {
      this.set('currentUser', currentUser);
      this.render(hbs`{{demographic-form user=currentUser}}`);
      let text = this.$('').text();
      expect(text).to.have.string('Log in to update your approximate age group and gender');
    });
  });

  context('given a currently authenticated user', function() {
    beforeEach(function(){
      manualSetup(this.container);
      currentUser = make('user', {
        gender: 'male',
        birthday: 1986,
      });
    });

    it('displays their gender by default', function() {
      this.set('currentUser', currentUser);
      this.render(hbs`{{demographic-form user=currentUser}}`);
      let text = this.$('#gender-dropdown .text').text();
      expect(text).to.have.string('Male');
    });

    it('displays their age group by default', function() {
      this.set('currentUser', currentUser);
      this.render(hbs`{{demographic-form user=currentUser}}`);
      let text = this.$('#ageGroup-dropdown .text').text();
      expect(text).to.have.string('30-34');
    });
  });
});
