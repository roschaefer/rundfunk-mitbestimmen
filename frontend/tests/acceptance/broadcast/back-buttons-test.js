import { describe, it, context, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../../helpers/start-app';
import destroyApp from '../../helpers/destroy-app';
import { mockSetup, mockTeardown, mockFindAll, makeList } from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

describe('Acceptance | broadcast/', function() {
  let application, broadcasts, broadcastsMock;

  beforeEach(function() {
    application = startApp();
    mockSetup();
    broadcastsMock = mockFindAll('broadcast');
    mockFindAll('station');
    mockFindAll('medium');
  });

  afterEach(function() {
    mockTeardown();
    destroyApp(application);
  });

  context('logged in', function() {
    beforeEach(function() {
      const sessionData = {idToken : 1};
      authenticateSession(application, sessionData);
    });

    it('can navigate to /broadcast/edit', function() {
      broadcasts = makeList('broadcast', 1)
      broadcastsMock.returns({json: broadcasts})
      visit('/find-broadcasts/');
      click('.broadcast-details');
      click('a.button.bottom.attached');

      return andThen(() => {
        expect(currentURL()).to.match(/\/broadcast\/\d+\/edit/);
      });
    });

    it('can navigate back from /broadcast/edit', function() {
      broadcasts = makeList('broadcast', 1)
      broadcastsMock.returns({json: broadcasts})
      visit('/find-broadcasts/');
      click('.broadcast-details');
      click('a.button.bottom.attached');
      click('.back.button');

      return andThen(() => {
        expect(currentURL()).to.match(/\/broadcast\/\d+\//);
      });
    });
  });
});
