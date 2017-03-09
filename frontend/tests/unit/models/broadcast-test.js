import { moduleForModel, test } from 'ember-qunit';
import { make } from 'ember-data-factory-guy';
import Ember from 'ember';
import startApp from '../../helpers/start-app';

let App;

moduleForModel('broadcast', 'Unit | Model | broadcast', {
  // Specify the other units that are required for this test.
  setup: function() {
    Ember.run(function() {
      App = startApp();
    });
  },
  teardown: function() {
    Ember.run(function() {
      App.destroy();
    });
  },
  needs: ['model:topic', 'model:format', 'model:selection', 'model:medium', 'model:station']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

test('respond response must be "positive" or "negative"', function(assert) {
  let model = this.subject();
  let selection = model.respond('foobar');
  assert.equal(selection, null);
  assert.equal(model.get('selections').get('length'), 0);
});

test('respond returns a new selection with the response', function(assert) {
  let model = this.subject();
  let selection = model.respond('positive');
  assert.equal(selection.get('response'), 'positive');
});

test('respond adds a new selection to the broadcast', function(assert) {
  let model = this.subject();
  model.respond('positive');
  assert.equal(model.get('selections').get('length'), 1);
});

test('respond updates the current selection if any', function(assert) {
  let model = this.subject();
  let selection = make('selection', {response: 'neutral'});
  Ember.run(function() {
    model.set('selections', [selection]);
    model.respond('positive');
  });
  assert.equal(selection.get('response'), 'positive');
});

test('respond updates and does not create more than one selection', function(assert) {
  let model = this.subject();
  let selection = make('selection', {response: 'neutral'});
  Ember.run(function() {
    model.set('selections', [selection]);
    assert.equal(model.get('selections').get('length'), 1);
    model.respond('positive');
  });
  assert.equal(model.get('selections').get('length'), 1);
});

test('respond "neutral" clears the amount', function(assert) {
  let model = this.subject();
  let selection = make('selection', {
    response: 'neutral',
    amount: 5.0,
  });
  Ember.run(function() {
    model.set('selections', [selection]);
    model.respond('neutral');
    assert.equal(selection.get('response'), 'neutral');
    assert.equal(selection.get('amount'), null);
  });
});

test('respond "neutral" will also unfix the amount', function(assert) {
  let model = this.subject();
  let selection = make('selection', {
    response: 'positive',
    fixed: true,
    amount: 5.0,
  });
  Ember.run(function() {
    model.set('selections', [selection]);
    model.respond('neutral');
    assert.equal(selection.get('response'), 'neutral');
    assert.equal(selection.get('amount'), null);
    assert.equal(selection.get('fixed'), false);
  });
});

test('respond "positive" keeps the amount', function(assert) {
  let model = this.subject();
  let selection = make('selection', {
    response: 'positive',
    amount: 5.0,
  });
  Ember.run(function() {
    model.set('selections', [selection]);
    model.respond('positive');
    assert.equal(selection.get('response'), 'positive');
    assert.equal(selection.get('amount'), 5.0);
  });
});
