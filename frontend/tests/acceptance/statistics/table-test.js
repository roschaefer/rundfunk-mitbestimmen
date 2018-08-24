import { describe, it, context, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from 'frontend/tests/helpers/start-app';
import destroyApp from 'frontend/tests/helpers/destroy-app';
import { buildList, mockFindAll } from 'ember-data-factory-guy';

describe('Acceptance | statistics/table', function() {
  let application;

  beforeEach(function() {
    application = startApp();
  });

  afterEach(function() {
    destroyApp(application);
  });

  describe('visit /statistics', function() {
    context('with some broadcasts statistics', function() {
      beforeEach(function(){
        const statistics = buildList('statistic/broadcast', {
          title: 'A title',
          impressions:  3,
          approval: 0.4,
          average: 4.3,
          total: 10.1
        }, {
          title: 'Recently created broadcast',
          impressions: 0,
          approval: null,
          average: null,
          total: 0
        });

        mockFindAll('statistic/broadcast').returns({
          json: statistics
        });
      });

      it('formats data', function() {
        visit('/statistics');

        return andThen(() => {
          const firstRow = find('.statistic-item:first').text()
          const secondRow = find('.statistic-item:last').text()
          expect(firstRow).to.include('40%');
          expect(firstRow).to.include('€4.30');
          expect(firstRow).to.include('€10.10');

          expect(secondRow).to.include('???');
        });
      });
    });
  });
});
