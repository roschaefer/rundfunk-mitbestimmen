import { describe, it, context, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../../helpers/start-app';
import destroyApp from '../../helpers/destroy-app';
import { mockSetup, mockTeardown, mockFindAll, mockQuery, buildList } from 'ember-data-factory-guy';

describe('Acceptance | find broadcasts/close login window', function() {
  let application, broadcasts, broadcastsMock;
  let message = 'To keep access to your data';

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


  context('unauthenticated user', function() {
    context('given 12 broadcasts', function() {
      beforeEach(function() {
        broadcasts = buildList('broadcast', 12).add({ meta: { 'total-pages': 2, 'total-count': 12} });
        broadcastsMock.returns({json: broadcasts});
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
              // also no Error: The adapter operation was aborted
            });
          })
        })

        describe('click on the next button', function(){
          it('sends no requests to the backend', function() {
            visit('/find-broadcasts/');
            click('.find-broadcasts-navigation-next');
            return andThen(() => {
              // no Error: The adapter operation was aborted
            });
          })
        })
      })
    })
  })
});
