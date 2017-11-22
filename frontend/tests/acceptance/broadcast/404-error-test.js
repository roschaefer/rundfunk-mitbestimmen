import { context, describe, it, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../../helpers/start-app';
import destroyApp from '../../helpers/destroy-app';
import { make, mockFindRecord } from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

describe('Acceptance | broadcast/ 404 error', function() {
  let application, broadcast, broadcastMock;

  beforeEach(function() {
    application = startApp();
    broadcastMock = mockFindRecord('broadcast');
  });

  afterEach(function() {
    destroyApp(application);
  });

  context('logged in', function() {
    beforeEach(function() {
      const sessionData = {idToken : 1};
      authenticateSession(application, sessionData);
    });

    context('backend route /broadcast/:broadcast_id', function() {
      beforeEach(function() {
        broadcast = make('broadcast', {
          title: 'This is the title'
        })
        broadcastMock.returns({model: broadcast});
      });


      it('shows the broadcast page', function() {
        visit('/broadcast/' + broadcastMock.get('id'));

        return andThen(() => {
          expect(find('.title.header').text()).to.have.string('This is the title');
        });
      });
    });

    describe('HTTP 404 from backend', function() {
      beforeEach(function() {
        broadcastMock.fails({status: 404});
      });

      it('shows a 404 error page', function() {
        visit('/broadcast/' + broadcastMock.get('id'));

        return andThen(() => {
          expect(find('p').text()).to.have.string('We could not find that page');
        });
      });
    });
  });
});
