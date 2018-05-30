import { expect } from 'chai';
import { describe, it, context, beforeEach, afterEach } from 'mocha';
import startApp from 'frontend/tests/helpers/start-app';
import destroyApp from 'frontend/tests/helpers/destroy-app';
import { mockQueryRecord, mockUpdate, make } from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import moment from 'moment';

describe('Acceptance | visualize/demography', function() {

  let application;

  beforeEach(function() {
    application = startApp();
    mockQueryRecord('summarized-statistic');
  });

  afterEach(function() {
    destroyApp(application);
  });

  it('can visit /visualize/demography', function() {
    visit('/visualize/demography');

    return andThen(() => {
      expect(currentURL()).to.equal('/visualize/demography');
    });
  });

  it('has a population pyramid', function() {
    visit('/visualize/demography');

    return andThen(() => {
      expect(find('.huge.header').text()).to.have.string('population pyramid');
    });
  });

  context('logged in', function() {
    beforeEach(function() {
      const sessionData = {idToken : 1};
      authenticateSession(application, sessionData);
    });

    describe('selecting gender from dropdown', function() {
      it("updates user's gender", function() {
        let user = make('user', {gender: 'male'});
        let userMock = mockQueryRecord('user');
        userMock.returns({model: user});
        let updateUserMock = mockUpdate('user').match({gender: 'female'});

        visit('/visualize/demography');
        click('#gender-dropdown');
        keyEvent('.menu');
        click('.item:contains(Female)');

        return andThen(() => {
          expect(updateUserMock.timesCalled).to.equal(1);
        });
      });
    });

    describe('selecting age group from dropdown', function() {
      it('updates user\'s approx birthday', function() {
        let user = make('user');
        let userMock = mockQueryRecord('user');
        userMock.returns({model: user});
        let expectedDate = new moment();
        expectedDate = expectedDate.subtract(32.5, 'years');
        expectedDate = expectedDate.startOf('day');
        let updateUserMock = mockUpdate('user').match((userInfo) => {
          console.log("This is the userinfo", userInfo);
          return true
        });
        visit('/visualize/demography');
        click('#ageGroup-dropdown');
        keyEvent('.menu');
        click('.item:contains(30-34)');

        return andThen(() => {
          expect(updateUserMock.timesCalled).to.equal(1);
        });
      });
    });
  });
});
