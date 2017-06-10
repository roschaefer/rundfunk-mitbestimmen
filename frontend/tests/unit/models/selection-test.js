import { expect } from 'chai';
import { beforeEach, describe, it, context } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Unit | Model | selection', function() {
  setupModelTest('selection', {
    needs: ['model:broadcast']
  });
  beforeEach(function() {
    manualSetup(this.container);
  });

  it('exists', function() {
    let model = this.subject();
    expect(model).to.be.ok;
  });

  describe('needsAmount', function(){
    let selection;

    context('neutral selection', function() {
      it('returns false', function() {
        selection = make('selection', {
          response: 'neutral'
        });
        expect(selection.get('needsAmount')).to.be.false;
      });
    });

    context('positive selection', function() {
      context('without amount', function() {
        it('returns true', function() {
          selection = make('selection', {
            response: 'positive',
          });
          expect(selection.get('needsAmount')).to.be.true;
        });
      });

      context('with amount', function() {
        it('returns true', function() {
          selection = make('selection', {
            response: 'positive',
            amount: 10.5
          });
          expect(selection.get('needsAmount')).to.be.false;
        });
      });
    });

  });
});
