import { context, describe, it, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../helpers/start-app';
import destroyApp from '../helpers/destroy-app';
import {
  mockSetup,
  mockTeardown,
  mockFindRecord
} from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

describe('Acceptance | Errors', function() {
  let application, broadcastMock;
  beforeEach(function() {
    application = startApp();
    mockSetup();
    broadcastMock = mockFindRecord('broadcast');
  });
  afterEach(function() {
    mockTeardown();
    destroyApp(application);
  });

  context('logged in', function() {
    beforeEach(function() {
      const sessionData = { idToken: 1 };
      authenticateSession(application, sessionData);
    });

    describe('HTTP 500 from backend', function() {
      beforeEach(function() {
        broadcastMock.fails({ status: 500 });
      });

      it('shows an error page', function() {
        visit('/invoice');
        return andThen(() => {
          expect(find('p').text()).to.have.string('Hm, something went wrong');
        });
      });
    });
  });
});
