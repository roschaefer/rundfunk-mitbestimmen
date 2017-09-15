import { describe, it, context, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../../helpers/start-app';
import destroyApp from '../../helpers/destroy-app';
import { mockSetup, mockTeardown, mockFindAll, mockQuery, buildList } from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

describe('Acceptance | broadcast/ navigation', function() {
  let application, broadcasts, broadcastsMock;

  beforeEach(function() {
    application = startApp();
    mockSetup();
    broadcastsMock = mockQuery('broadcast');
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
      broadcasts = buildList('broadcast', 1).add({ meta: { 'total-pages': 1, 'total-count': 1 } });
      broadcastsMock.returns({json: broadcasts})
      visit('/find-broadcasts/');
      click('.broadcast-details');
      click('.edit.button');
      return andThen(() => {
        expect(currentURL()).to.match(/^\/broadcast\/\d+\/edit$/);
      });
    });
  });
});
