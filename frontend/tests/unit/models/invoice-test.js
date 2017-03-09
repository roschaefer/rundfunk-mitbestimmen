import { moduleForModel, test } from 'ember-qunit';
import { make } from 'ember-data-factory-guy';
import Ember from 'ember';
import startApp from '../../helpers/start-app';

let App;

moduleForModel('invoice', 'Unit | Model | invoice', {
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
  needs: ['model:selection']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

test('#distributeEvenly distributes some money evenly among selections', function(assert) {
  let model = this.subject();
  let s1 = make('selection', {amount: 10.0});
  let s2 = make('selection', {amount: 7.5});
  Ember.run(function() {
    model.distributeEvenly([s1,s2], 10);
  });
  assert.equal(s1.get('amount'), 5.0);
  assert.equal(s2.get('amount'), 5.0);
});

test('#distributeEvenly floors to 2 decimal places', function(assert) {
  let model = this.subject();
  // let store = this.store();
  let s1 = make('selection');
  let s2 = make('selection');
  let s3 = make('selection');
  [s1,s2,s3].forEach((s) => { model.get('selections').pushObject(s); });
  model.distributeEvenly([s1,s2,s3], 17.0);
  assert.equal(s1.get('amount'), 5.66);
  assert.equal(s2.get('amount'), 5.66);
  assert.equal(s3.get('amount'), 5.66);
});

test('#redistribute budget evenly among unfixed selections', function(assert) {
  let model = this.subject();
  // let store = this.store();
  let s1 = make('selection');
  let s2 = make('selection');
  [s1,s2].forEach((s) => { model.get('selections').pushObject(s); });
  model.redistribute();
  assert.equal(s1.get('amount'), 8.75);
  assert.equal(s2.get('amount'), 8.75);
});

test('#redistribute budget evenly, but do not touch fixed selections', function(assert) {
  let model = this.subject();
  // let store = this.store();
  let s1 = make('selection', {amount: 6.5, fixed: true});
  let s2 = make('selection', {amount: 4.0, fixed: true});
  let s3 = make('selection');
  let s4 = make('selection');
  [s1,s2,s3,s4].forEach((s) => { model.get('selections').pushObject(s); });
  model.redistribute();
  assert.equal(s1.get('amount'), 6.5);
  assert.equal(s2.get('amount'), 4.0);
  assert.equal(s3.get('amount'), 3.5);
  assert.equal(s4.get('amount'), 3.5);
});

test('#remove selection distributes money among unfixed selections', function(assert) {
  let model = this.subject();
  // let store = this.store();
  let s1       = make('selection', {amount: 2.5, fixed: true});
  let s2       = make('selection', {amount: 6.0});
  let toRemove = make('selection', {amount: 3.0, fixed: true});
  let s4       = make('selection', {amount: 6.0});
  [s1,s2,toRemove,s4].forEach((s) => { model.get('selections').pushObject(s); });
  model.remove(toRemove);
  assert.equal(s1.get('amount'), 2.5);
  assert.equal(s2.get('amount'), 7.5);
  assert.equal(s4.get('amount'), 7.5);
  assert.equal(model.get('selections').get('length'), 3); // actually removed
});

test('#initializeAmounts assigns free budget to selections without amount', function(assert) {
  let model = this.subject();
  // let store = this.store();
  let s1 = make('selection', {amount: null});
  let s2 = make('selection', {amount: null});
  let s3 = make('selection', {amount: 2.5, fixed: true});
  [s1,s2,s3].forEach((s) => { model.get('selections').pushObject(s); });
  model.initializeAmounts();
  assert.equal(s1.get('amount'), 7.5);
  assert.equal(s2.get('amount'), 7.5);
  assert.equal(s3.get('amount'), 2.5);
});

test('#reduceFirstSelections is a convenience method to early avoid invalid records', function(assert) {
  let model = this.subject();
  let s1 = make('selection', {amount: null, fixed: false});
  let s2 = make('selection', {amount: 3.5, fixed: false});
  let s3 = make('selection', {amount: 2.5, fixed: true});
  Ember.run(function() {
    model.set('selections', [s1,s2,s3]);
    let reduceFirstSelections = model.reduceFirstSelections();
    assert.equal(reduceFirstSelections.get('length'), 1);
    assert.equal(reduceFirstSelections.objectAt(0), s2);
  });
});

test('#allocate tries to allocate some budget for a selection', function(assert) {
  let model = this.subject();
  // let store = this.store();
  let s1 = make('selection', {amount: 7.5});
  let s2 = make('selection', {amount: 7.5});
  let s3 = make('selection', {amount: 2.5, fixed: true});
  [s1,s2,s3].forEach((s) => { model.get('selections').pushObject(s); });
  model.allocate(s2, 8.5);
  assert.equal(s1.get('amount'), 6.5);
  assert.equal(s2.get('amount'), 7.5);
  assert.equal(s3.get('amount'), 2.5);
});

test('#allocate returns the maximum possible amount', function(assert) {
  let model = this.subject();
  // let store = this.store();
  let s1 = make('selection', {amount: 7.5});
  let s2 = make('selection', {amount: 7.5});
  let s3 = make('selection', {amount: 2.5, fixed: true});
  [s1,s2,s3].forEach((s) => { model.get('selections').pushObject(s); });
  let maximumAmount = model.allocate(s2, 16.0);
  assert.equal(s1.get('amount'), 0);
  assert.equal(s2.get('amount'), 7.5);
  assert.equal(s3.get('amount'), 2.5);
  assert.equal(maximumAmount, 15.0);
});

test('#allocate returns the maximum possible amount, floored to two decimals', function(assert) {
  let model = this.subject();
  // let store = this.store();
  let s1 = make('selection');
  let s2 = make('selection');
  let s3 = make('selection');
  let s4 = make('selection');
  [s1,s2,s3,s4].forEach((s) => { model.get('selections').pushObject(s); });
  let maximumAmount = model.allocate(s2, 5.326);
  assert.equal(s1.get('amount'), 4.06);
  assert.equal(maximumAmount, 5.32);
  assert.equal(s3.get('amount'), 4.06);
  assert.equal(s4.get('amount'), 4.06);
});
