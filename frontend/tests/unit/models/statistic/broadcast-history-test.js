import { expect } from 'chai';
import { beforeEach, describe, it, context } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Unit | Model | statistic/broadcast history', function() {
  setupModelTest('statistic/broadcast-history', {
    // Specify the other units that are required for this test.
    needs: ['model:statistic/broadcast-history']
  });
  beforeEach(function() {
    manualSetup(this.container);
  });

  // Replace this with your real tests.
  it('exists', function() {
    let model = this.subject();
    // var store = this.store();
    expect(model).to.be.ok;
  });


  context('given a new broadcast with no impressions 3 months ago', function() {
    let model;
    beforeEach(function() {
      model = make('statistic/broadcast-history', {
        approval: [null, 0.8],
        average: [null, 2.0],
        impressions: [null, 5],
        total: [null, 8.0]
      });
    });

    it('#approvalDelta == null', function() {
      this.subject();
      // var store = this.store();
      expect(model.get('approvalDelta')).to.eq(null);
    });

    it('#averageDelta == null', function() {
      this.subject();
      // var store = this.store();
      expect(model.get('averageDelta ')).to.eq(null);
    });

    it('#impressionsDelta == 5', function() {
      this.subject();
      // var store = this.store();
      expect(model.get('impressionsDelta')).to.eq(5);
    });

    it('#totalDelta == 8.0', function() {
      this.subject();
      // var store = this.store();
      expect(model.get('impressionsDelta')).to.eq(8.0);
    });
  });
});
