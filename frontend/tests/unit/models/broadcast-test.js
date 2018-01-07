import Ember from 'ember';
import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Unit | Model | broadcast', function() {
  setupModelTest('broadcast', {
    // Specify the other units that are required for this it.
    needs: ['model:impression', 'model:medium', 'model:station']
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

  describe('setDefaultResponse', function() {
    it('creates a impression with a response', function() {
      let broadcast = make('broadcast');
      broadcast.setDefaultResponse('positive');
      expect(broadcast.get('response')).to.eq('positive');
    });

    it('leaves existing impression untouched', function() {
      let broadcast = make('broadcast');
      make('impression', {
        broadcast: broadcast,
        response: 'neutral'
      });
      broadcast.setDefaultResponse('positive');
      expect(broadcast.get('response')).to.eq('neutral');
    });
  });

  describe('response', function() {
    it('undefined if no impressions', function() {
      let broadcast = make('broadcast');
      expect(broadcast.get('response')).to.be.undefined;
    });

    it('returns the response of the first impression', function() {
      let broadcast = make('broadcast');
      make('impression', {
        broadcast: broadcast,
        response: 'positive'
      });
      expect(broadcast.get('response')).to.eq('positive');
    });
  });

  describe('respond(response)', function() {
    it('response must be "positive" or "negative"', function() {
      let model = this.subject();
      let impression;
      Ember.run(() => {
        impression = model.respond('foobar');
      });
      expect(impression).to.be.undefined;
      expect(model.get('impressions').get('length')).to.eq(0);
    });

    it('returns a new impression with the response', function() {
      let model = this.subject();
      let impression;
      Ember.run(() => {
        impression = model.respond('positive');
      });
      expect(impression.get('response')).to.eq('positive');
    });

    it('adds a new impression to the broadcast', function() {
      let model = this.subject();
      Ember.run(() => {
         model.respond('positive');
      });
      expect(model.get('impressions').get('length')).to.eq(1);
    });

    it('updates the current impression if any', function() {
      let model = this.subject();
      let impression = make('impression', {response: 'neutral'});
      Ember.run(function() {
        model.set('impressions', [impression]);
        model.respond('positive');
      });
      expect(impression.get('response')).to.eq('positive');
    });
  });

  it('respond updates and does not create more than one impression', function() {
    let model = this.subject();
    let impression = make('impression', {response: 'neutral'});
    Ember.run(function() {
      model.set('impressions', [impression]);
      expect(model.get('impressions').get('length')).to.eq(1);
      model.respond('positive');
    });
    expect(model.get('impressions').get('length')).to.eq(1);
  });

  it('respond "neutral" clears the amount', function() {
    let model = this.subject();
    let impression = make('impression', {
      response: 'neutral',
      amount: 5.0,
    });
    Ember.run(function() {
      model.set('impressions', [impression]);
      model.respond('neutral');
      expect(impression.get('response')).to.eq('neutral');
      expect(impression.get('amount')).to.eq(null);
    });
  });

  it('respond "neutral" will also unfix the amount', function() {
    let model = this.subject();
    let impression = make('impression', {
      response: 'positive',
      fixed: true,
      amount: 5.0,
    });
    Ember.run(function() {
      model.set('impressions', [impression]);
      model.respond('neutral');
      expect(impression.get('response')).to.eq('neutral');
      expect(impression.get('amount')).to.eq(null);
      expect(impression.get('fixed')).to.eq(false);
    });
  });

  it('respond "positive" keeps the amount', function() {
    let model = this.subject();
    let impression = make('impression', {
      response: 'positive',
      amount: 5.0,
    });
    Ember.run(function() {
      model.set('impressions', [impression]);
      model.respond('positive');
      expect(impression.get('response')).to.eq('positive');
      expect(impression.get('amount')).to.eq(5.0);
    });
  });
});
