import Ember from 'ember';
import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Unit | Model | broadcast', function() {
  setupModelTest('broadcast', {
    // Specify the other units that are required for this it.
    needs: ['model:selection', 'model:medium', 'model:station']
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
    it('creates a selection with a response', function() {
      let broadcast = make('broadcast');
      broadcast.setDefaultResponse('positive');
      expect(broadcast.get('response')).to.eq('positive');
    });

    it('leaves existing selection untouched', function() {
      let broadcast = make('broadcast');
      make('selection', {
        broadcast: broadcast,
        response: 'neutral'
      });
      broadcast.setDefaultResponse('positive');
      expect(broadcast.get('response')).to.eq('neutral');
    });
  });

  describe('response', function() {
    it('undefined if no selections', function() {
      let broadcast = make('broadcast');
      expect(broadcast.get('response')).to.be.undefined;
    });

    it('returns the response of the first selection', function() {
      let broadcast = make('broadcast');
      make('selection', {
        broadcast: broadcast,
        response: 'positive'
      });
      expect(broadcast.get('response')).to.eq('positive');
    });
  });

  describe('respond(response)', function() {
    it('response must be "positive" or "negative"', function() {
      let model = this.subject();
      let selection = model.respond('foobar');
      expect(selection).to.be.undefined;
      expect(model.get('selections').get('length')).to.eq(0);
    });

    it('returns a new selection with the response', function() {
      let model = this.subject();
      let selection = model.respond('positive');
      expect(selection.get('response')).to.eq('positive');
    });

    it('adds a new selection to the broadcast', function() {
      let model = this.subject();
      model.respond('positive');
      expect(model.get('selections').get('length')).to.eq(1);
    });

    it('updates the current selection if any', function() {
      let model = this.subject();
      let selection = make('selection', {response: 'neutral'});
      Ember.run(function() {
        model.set('selections', [selection]);
        model.respond('positive');
      });
      expect(selection.get('response')).to.eq('positive');
    });
  });

  it('respond updates and does not create more than one selection', function() {
    let model = this.subject();
    let selection = make('selection', {response: 'neutral'});
    Ember.run(function() {
      model.set('selections', [selection]);
      expect(model.get('selections').get('length')).to.eq(1);
      model.respond('positive');
    });
    expect(model.get('selections').get('length')).to.eq(1);
  });

  it('respond "neutral" clears the amount', function() {
    let model = this.subject();
    let selection = make('selection', {
      response: 'neutral',
      amount: 5.0,
    });
    Ember.run(function() {
      model.set('selections', [selection]);
      model.respond('neutral');
      expect(selection.get('response')).to.eq('neutral');
      expect(selection.get('amount')).to.eq(null);
    });
  });

  it('respond "neutral" will also unfix the amount', function() {
    let model = this.subject();
    let selection = make('selection', {
      response: 'positive',
      fixed: true,
      amount: 5.0,
    });
    Ember.run(function() {
      model.set('selections', [selection]);
      model.respond('neutral');
      expect(selection.get('response')).to.eq('neutral');
      expect(selection.get('amount')).to.eq(null);
      expect(selection.get('fixed')).to.eq(false);
    });
  });

  it('respond "positive" keeps the amount', function() {
    let model = this.subject();
    let selection = make('selection', {
      response: 'positive',
      amount: 5.0,
    });
    Ember.run(function() {
      model.set('selections', [selection]);
      model.respond('positive');
      expect(selection.get('response')).to.eq('positive');
      expect(selection.get('amount')).to.eq(5.0);
    });
  });
});
