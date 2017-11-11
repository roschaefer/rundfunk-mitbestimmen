import { describe, it, context, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../../helpers/start-app';
import destroyApp from '../../helpers/destroy-app';
import { mockSetup, mockTeardown, mock, mockFindAll, mockQuery, mockCreate, buildList } from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

describe('Acceptance | find broadcasts/close login window', function() {
  let application, broadcasts, broadcastsMock, impressionUpdateMock;
  let message = 'To keep access to your data';

  beforeEach(function() {
    application = startApp();
    mockSetup();
    broadcastsMock = mockQuery('broadcast');
    impressionUpdateMock = mockCreate('impression');
    mockFindAll('station');
    mockFindAll('medium');
  });


  afterEach(function() {
    mockTeardown();
    destroyApp(application);
  });


  context('given 12 broadcasts', function() {
    beforeEach(function() {
      broadcasts = buildList('broadcast', 12).add({ meta: { 'total-pages': 2, 'total-count': 12} });
      broadcastsMock.returns({json: broadcasts});
    });

    context('unauthenticated user', function() {
      beforeEach(function() {
        mock({type: 'GET', url: 'https://rundfunk-testing.eu.auth0.com/user/geoloc/country', responseText: {}});
      });

      describe('visit /find-broadcasts', function(){
        it('does not show the login dialog', function() {
          visit('/find-broadcasts/');
          return andThen(() => {
            expect(find('.auth0-lock')).to.have.length(0);
          });
        })

        describe('click on support button', function(){
          it('opens the login dialog', function() {
            visit('/find-broadcasts/');
            click('.decision-card-support-button');
            return andThen(() => {
              expect(find('.auth0-lock-widget-container').text().trim()).to.have.string(message);
              expect(impressionUpdateMock.timesCalled).to.equal(0);
            });
          })
        })

        describe('click on the next button', function(){
          it('sends no requests to the backend', function() {
            visit('/find-broadcasts/');
            click('.find-broadcasts-navigation-next');
            return andThen(() => {
              expect(impressionUpdateMock.timesCalled).to.equal(0);
            });
          })
        })
      })
    })

    context('authenticated user', function() {
      beforeEach(function() {
        const sessionData = {idToken : 1};
        authenticateSession(application, sessionData);
      });

      describe('visit /find-broadcast', function(){
        it('sends a parameter ?mark_as_seen=true', function() {
          broadcastsMock = mockQuery('broadcast');
          visit('/find-broadcasts/');
          return andThen(() => {
            expect(broadcastsMock.timesCalled).to.equal(1);
          });
        });
      });

      describe('click on support button', function(){
        it('creates a positive impression', function() {
          visit('/find-broadcasts/');
          impressionUpdateMock = mockCreate('impression').match({
            response: 'positive'
          });
          click('.decision-card-support-button');
          return andThen(() => {
            expect(impressionUpdateMock.timesCalled).to.equal(1);
          });
        })
      })
    });
  })
});
