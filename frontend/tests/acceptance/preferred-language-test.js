import { describe, context, it, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../helpers/start-app';
import destroyApp from '../helpers/destroy-app';
import { mockSetup, mockTeardown, mockQueryRecord, mockUpdate, build } from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

describe('Acceptance | preferred language', function() {
  let application, user, userMock;
  const english = "Don't you want to get a say?";
  const german  = "Du zahlst jeden Monat";

  beforeEach(function() {
    application = startApp();
    mockSetup();
    user = build('user');
    userMock = mockQueryRecord('user').returns({json: user});

    const summarizedStatistic = build('summarized-statistic', {
      broadcasts: 1,
      registeredUsers: 2,
      impressions: 3,
      assignedMoney: 4
    });
    mockQueryRecord('summarized-statistic').returns({json: summarizedStatistic});
  });

  afterEach(function() {
    mockTeardown();
    destroyApp(application);
  });

  describe('browser default language', function() {
    context('neither "de" nor "en"', function(){
      beforeEach(function() {
        Object.defineProperty(navigator, 'language', {
          configurable: true,
          value: 'it'
        });
      });

      afterEach(function() {
        delete navigator.language;
      });

      it('fallback to "en"', function() {
        visit('/');
        return andThen(() => {
          expect(find('.start-question').text().trim()).to.have.string(english);
        });
      })
    });
  });

  describe('change language', function() {
    it('changes the language', function(){
      visit('/');
      return andThen(() => {
        expect(find('.start-question').text().trim()).to.have.string(english);
        click('.language.item i.de.flag')
        return andThen(() => {
          expect(find('.start-question').text().trim()).to.have.string(german);
        });
      });
    });
  });

  context('logged in', function() {
    beforeEach(function() {
      const sessionData = {idToken : 1};
      authenticateSession(application, sessionData);
    });

    describe('change language', function() {
      it('changes the language', function(){
        mockUpdate('user');
        visit('/');
        return andThen(() => {
          expect(find('.start-question').text().trim()).to.have.string(english);
          click('.language.item i.de.flag')
          return andThen(() => {
            expect(find('.start-question').text().trim()).to.have.string(german);
          });
        });
      });

      it('saves user locale to the backend', function(){
        const userUpdateMock = mockUpdate('user').match({locale: 'de'});
        visit('/');
        click('.language.item i.de.flag')
        return andThen(() => {
          expect(userUpdateMock .timesCalled).to.equal(1);
        });
      });
    });

    describe('successful login', function() {
      it('redirects to /', function() {
        visit('authentication/callback');
        return andThen(() => {
          expect(currentURL()).to.equal('/');
        });
      });

      context('user has a preferred language', function() {
        beforeEach(function() {
          user = build('user', {
            locale: 'de'
          });
          userMock.returns({json: user});
        });

        it('translates the page accordingly', function() {
          visit('authentication/callback');
          return andThen(() => {
            expect(find('.start-question').text().trim()).to.have.string(german);
          });
        });
      });
    });
  });
});
