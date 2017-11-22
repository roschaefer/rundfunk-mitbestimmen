import { describe, context, it, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../../../helpers/start-app';
import destroyApp from '../../../helpers/destroy-app';
import { mock, mockUpdate, mockQueryRecord, make } from 'ember-data-factory-guy';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

describe('Acceptance | visualize/geo update location', function() {
  let application;
  let user, userMock;

  beforeEach(function() {
    application = startApp();
    mockQueryRecord('summarized-statistic');
    userMock = mockQueryRecord('user');
    const payload = {
      type: 'FeatureCollection',
      features: [
        { type: 'Feature', properties: {}, geometry: {
          type: 'Polygon', coordinates: [
            [
              [ 8.1298828125, 48.850258199721495 ],
              [ 11.97509765625, 48.850258199721495 ],
              [ 11.97509765625, 52.92215137976296 ],
              [ 8.1298828125, 52.92215137976296 ],
              [ 8.1298828125, 48.850258199721495 ]
            ]]
        }}
      ]
    };
    mock({type: 'GET', url: 'http://localhost:3001/chart_data/geo/geojson', responseText: payload})
  });

  afterEach(function() {
    destroyApp(application);
  });


  context('not logged in', function() {
    it('can visit /visualize-geo', function() {
      visit('/visualize/geo');
      return andThen(() => { expect(currentURL()).to.equal('/visualize/geo'); });
    });

    it('asks to log in', function() {
      userMock.fails({status: 401});
      visit('/visualize/geo');
      return andThen(() => {
        expect(find('.update-location-hint').text()).to.include('Log in to add your location');
        expect(find('.update-location-hint button').text()).to.include('Log in');
      });
    });
  });

  context('logged in', function() {
    beforeEach(function() {
      const sessionData = {idToken : 1};
      authenticateSession(application, sessionData);
    });

    context('user has no location', function() {
      it('is asked to add a new location', function() {
        user = make('user', {
          latitude: null,
          longitude: null
        });
        userMock.returns({model: user})
        mockUpdate(user);
        visit('/visualize/geo');
        return andThen(() => {
          expect(find('.update-location-hint button').text()).to.include('Add location');
        });
      });

      it('can add a new location', function() {
        user = make('user');
        userMock.returns({model : user})
        mockUpdate(user);
        visit('/visualize/geo');
        click('.update-location-hint button');
        click('path.leaflet-interactive');
        return andThen(() => {
          expect(user.get('hasLocation')).to.be.true;
        });
      });
    });

    context('user has location already', function() {
      it('is asked to add a new location', function() {
        user = make('user', {
          latitude: 47,
          longitude: 11,
        });
        userMock.returns({model : user})
        visit('/visualize/geo');
        return andThen(() => {
          expect(find('.update-location-hint button').text()).to.include('Update location');
        });
      });
    });
  });
});
