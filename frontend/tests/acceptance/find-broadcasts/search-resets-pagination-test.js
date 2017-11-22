import { describe, it, context, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../../helpers/start-app';
import destroyApp from '../../helpers/destroy-app';
import { mockFindAll, mockQuery, mockCreate, buildList } from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

describe('Acceptance | find broadcasts/search resets pagination', function() {
  let application, broadcasts, broadcastsMock;

  beforeEach(function() {
    application = startApp();
    broadcastsMock = mockQuery('broadcast');
    mockCreate('impression');
    mockFindAll('station');
    mockFindAll('medium');
  });


  afterEach(function() {
    destroyApp(application);
  });

  context('logged in', function() {
    beforeEach(function() {
      const sessionData = {idToken : 1};
      authenticateSession(application, sessionData);
    });

    it('can visit /find-broadcasts/ search resets pagination', function() {
      broadcasts = buildList('broadcast', 6).add({ meta: { 'total-pages': 3, 'total-count': 18 } });
      broadcastsMock.returns({json: broadcasts});
      visit('/find-broadcasts/');
      click('.find-broadcasts-navigation-next');
      fillIn('input#search', 'Broadcast title');
      click('#submit-search')
      return andThen(() => {
        expect(currentURL()).to.equal('/find-broadcasts?q=Broadcast%20title');
      });
    });
  });
});
