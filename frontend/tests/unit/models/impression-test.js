import { expect } from 'chai';
import { beforeEach, describe, it, context } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Unit | Model | impression', function() {
  setupModelTest('impression', { integration: true });
  beforeEach(function() {
    manualSetup(this.container);
  });

  it('exists', function() {
    let model = this.subject();
    expect(model).to.be.ok;
  });

  describe('needsAmount', function(){
    let impression;

    context('neutral impression', function() {
      it('returns false', function() {
        impression = make('impression', {
          response: 'neutral'
        });
        expect(impression.get('needsAmount')).to.be.false;
      });
    });

    context('positive impression', function() {
      context('without amount', function() {
        it('returns true', function() {
          impression = make('impression', {
            response: 'positive',
          });
          expect(impression.get('needsAmount')).to.be.true;
        });
      });

      context('with amount', function() {
        it('returns true', function() {
          impression = make('impression', {
            response: 'positive',
            amount: 10.5
          });
          expect(impression.get('needsAmount')).to.be.false;
        });
      });
    });

  });
});
