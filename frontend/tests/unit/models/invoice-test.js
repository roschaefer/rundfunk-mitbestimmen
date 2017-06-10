import Ember from 'ember';
import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Unit | Model | invoice', function() {
  setupModelTest('invoice', {
    // Specify the other units that are required for this it.
    needs: ['model:selection']
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

  it('#distributeEvenly distributes some money evenly among selections', function() {
    let model = this.subject();
    let s1 = make('selection', {amount: 10.0});
    let s2 = make('selection', {amount: 7.5});
    Ember.run(function() {
      model.distributeEvenly([s1,s2], 10);
    });
    expect(s1.get('amount')).to.eq(5.0);
    expect(s2.get('amount')).to.eq(5.0);
  });

  it('#distributeEvenly floors to 2 decimal places', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('selection');
    let s2 = make('selection');
    let s3 = make('selection');
    [s1,s2,s3].forEach((s) => { model.get('selections').pushObject(s); });
    model.distributeEvenly([s1,s2,s3], 17.0);
    expect(s1.get('amount')).to.eq(5.66);
    expect(s2.get('amount')).to.eq(5.66);
    expect(s3.get('amount')).to.eq(5.66);
  });

  it('#redistribute budget evenly among unfixed selections', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('selection');
    let s2 = make('selection');
    [s1,s2].forEach((s) => { model.get('selections').pushObject(s); });
    model.redistribute();
    expect(s1.get('amount')).to.eq(8.75);
    expect(s2.get('amount')).to.eq(8.75);
  });

  it('#redistribute budget evenly, but do not touch fixed selections', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('selection', {amount: 6.5, fixed: true});
    let s2 = make('selection', {amount: 4.0, fixed: true});
    let s3 = make('selection');
    let s4 = make('selection');
    [s1,s2,s3,s4].forEach((s) => { model.get('selections').pushObject(s); });
    model.redistribute();
    expect(s1.get('amount')).to.eq(6.5);
    expect(s2.get('amount')).to.eq(4.0);
    expect(s3.get('amount')).to.eq(3.5);
    expect(s4.get('amount')).to.eq(3.5);
  });

  it('#remove selection distributes money among unfixed selections', function() {
    let model = this.subject();
    // let store = this.store();
    let s1       = make('selection', {amount: 2.5, fixed: true});
    let s2       = make('selection', {amount: 6.0});
    let toRemove = make('selection', {amount: 3.0, fixed: true});
    let s4       = make('selection', {amount: 6.0});
    [s1,s2,toRemove,s4].forEach((s) => { model.get('selections').pushObject(s); });
    model.remove(toRemove);
    expect(s1.get('amount')).to.eq(2.5);
    expect(s2.get('amount')).to.eq(7.5);
    expect(s4.get('amount')).to.eq(7.5);
    expect(model.get('selections').get('length')).to.eq(3); // actually removed
  });

  it('#initializeAmounts assigns free budget to selections without amount', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('selection', {amount: null});
    let s2 = make('selection', {amount: null});
    let s3 = make('selection', {amount: 2.5, fixed: true});
    [s1,s2,s3].forEach((s) => { model.get('selections').pushObject(s); });
    model.initializeAmounts();
    expect(s1.get('amount')).to.eq(7.5);
    expect(s2.get('amount')).to.eq(7.5);
    expect(s3.get('amount')).to.eq(2.5);
  });

  it('#reduceFirstSelections is a convenience method to early avoid invalid records', function() {
    let model = this.subject();
    let s1 = make('selection', {amount: null, fixed: false});
    let s2 = make('selection', {amount: 3.5, fixed: false});
    let s3 = make('selection', {amount: 2.5, fixed: true});
    Ember.run(function() {
      model.set('selections', [s1,s2,s3]);
      let reduceFirstSelections = model.reduceFirstSelections();
      expect(reduceFirstSelections.get('length')).to.eq(1);
      expect(reduceFirstSelections.objectAt(0)).to.eq(s2);
    });
  });

  it('#allocate tries to allocate some budget for a selection', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('selection', {amount: 7.5});
    let s2 = make('selection', {amount: 7.5});
    let s3 = make('selection', {amount: 2.5, fixed: true});
    [s1,s2,s3].forEach((s) => { model.get('selections').pushObject(s); });
    model.allocate(s2, 8.5);
    expect(s1.get('amount')).to.eq(6.5);
    expect(s2.get('amount')).to.eq(7.5);
    expect(s3.get('amount')).to.eq(2.5);
  });

  it('#allocate returns the maximum possible amount', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('selection', {amount: 7.5});
    let s2 = make('selection', {amount: 7.5});
    let s3 = make('selection', {amount: 2.5, fixed: true});
    [s1,s2,s3].forEach((s) => { model.get('selections').pushObject(s); });
    let maximumAmount = model.allocate(s2, 16.0);
    expect(s1.get('amount')).to.eq(0);
    expect(s2.get('amount')).to.eq(7.5);
    expect(s3.get('amount')).to.eq(2.5);
    expect(maximumAmount).to.eq(15.0);
  });

  it('#allocate returns the maximum possible amount, floored to two decimals', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('selection');
    let s2 = make('selection');
    let s3 = make('selection');
    let s4 = make('selection');
    [s1,s2,s3,s4].forEach((s) => { model.get('selections').pushObject(s); });
    let maximumAmount = model.allocate(s2, 5.326);
    expect(s1.get('amount')).to.eq(4.06);
    expect(maximumAmount).to.eq(5.32);
    expect(s3.get('amount')).to.eq(4.06);
    expect(s4.get('amount')).to.eq(4.06);
  });
});
