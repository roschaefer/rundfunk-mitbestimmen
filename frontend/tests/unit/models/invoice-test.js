import Ember from 'ember';
import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Unit | Model | invoice', function() {
  setupModelTest('invoice', {
    // Specify the other units that are required for this it.
    needs: ['model:impression']
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

  it('#distributeEvenly distributes some money evenly among impressions', function() {
    let model = this.subject();
    let s1 = make('impression', {amount: 10.0});
    let s2 = make('impression', {amount: 7.5});
    Ember.run(function() {
      model.distributeEvenly([s1,s2], 10);
    });
    expect(s1.get('amount')).to.eq(5.0);
    expect(s2.get('amount')).to.eq(5.0);
  });

  it('#distributeEvenly floors to 2 decimal places', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('impression');
    let s2 = make('impression');
    let s3 = make('impression');
    [s1,s2,s3].forEach((s) => { model.get('impressions').pushObject(s); });
    model.distributeEvenly([s1,s2,s3], 17.0);
    expect(s1.get('amount')).to.eq(5.66);
    expect(s2.get('amount')).to.eq(5.66);
    expect(s3.get('amount')).to.eq(5.66);
  });

  it('#redistribute budget evenly among unfixed impressions', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('impression');
    let s2 = make('impression');
    [s1,s2].forEach((s) => { model.get('impressions').pushObject(s); });
    model.redistribute();
    expect(s1.get('amount')).to.eq(8.75);
    expect(s2.get('amount')).to.eq(8.75);
  });

  it('#redistribute budget evenly, but do not touch fixed impressions', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('impression', {amount: 6.5, fixed: true});
    let s2 = make('impression', {amount: 4.0, fixed: true});
    let s3 = make('impression');
    let s4 = make('impression');
    [s1,s2,s3,s4].forEach((s) => { model.get('impressions').pushObject(s); });
    model.redistribute();
    expect(s1.get('amount')).to.eq(6.5);
    expect(s2.get('amount')).to.eq(4.0);
    expect(s3.get('amount')).to.eq(3.5);
    expect(s4.get('amount')).to.eq(3.5);
  });

  it('#remove impression distributes money among unfixed impressions', function() {
    let model = this.subject();
    // let store = this.store();
    let s1       = make('impression', {amount: 2.5, fixed: true});
    let s2       = make('impression', {amount: 6.0});
    let toRemove = make('impression', {amount: 3.0, fixed: true});
    let s4       = make('impression', {amount: 6.0});
    [s1,s2,toRemove,s4].forEach((s) => { model.get('impressions').pushObject(s); });
    model.remove(toRemove);
    expect(s1.get('amount')).to.eq(2.5);
    expect(s2.get('amount')).to.eq(7.5);
    expect(s4.get('amount')).to.eq(7.5);
    expect(model.get('impressions').get('length')).to.eq(3); // actually removed
  });

  it('#initializeAmounts assigns free budget to impressions without amount', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('impression', {amount: null});
    let s2 = make('impression', {amount: null});
    let s3 = make('impression', {amount: 2.5, fixed: true});
    [s1,s2,s3].forEach((s) => { model.get('impressions').pushObject(s); });
    model.initializeAmounts();
    expect(s1.get('amount')).to.eq(7.5);
    expect(s2.get('amount')).to.eq(7.5);
    expect(s3.get('amount')).to.eq(2.5);
  });

  it('#reduceFirstImpressions is a convenience method to early avoid invalid records', function() {
    let model = this.subject();
    let s1 = make('impression', {amount: null, fixed: false});
    let s2 = make('impression', {amount: 3.5, fixed: false});
    let s3 = make('impression', {amount: 2.5, fixed: true});
    Ember.run(function() {
      model.set('impressions', [s1,s2,s3]);
      let reduceFirstImpressions = model.reduceFirstImpressions();
      expect(reduceFirstImpressions.get('length')).to.eq(1);
      expect(reduceFirstImpressions.objectAt(0)).to.eq(s2);
    });
  });

  it('#allocate tries to allocate some budget for a impression', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('impression', {amount: 7.5});
    let s2 = make('impression', {amount: 7.5});
    let s3 = make('impression', {amount: 2.5, fixed: true});
    [s1,s2,s3].forEach((s) => { model.get('impressions').pushObject(s); });
    model.allocate(s2, 8.5);
    expect(s1.get('amount')).to.eq(6.5);
    expect(s2.get('amount')).to.eq(7.5);
    expect(s3.get('amount')).to.eq(2.5);
  });

  it('#allocate returns the maximum possible amount', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('impression', {amount: 7.5});
    let s2 = make('impression', {amount: 7.5});
    let s3 = make('impression', {amount: 2.5, fixed: true});
    [s1,s2,s3].forEach((s) => { model.get('impressions').pushObject(s); });
    let maximumAmount = model.allocate(s2, 16.0);
    expect(s1.get('amount')).to.eq(0);
    expect(s2.get('amount')).to.eq(7.5);
    expect(s3.get('amount')).to.eq(2.5);
    expect(maximumAmount).to.eq(15.0);
  });

  it('#allocate returns the maximum possible amount, floored to two decimals', function() {
    let model = this.subject();
    // let store = this.store();
    let s1 = make('impression');
    let s2 = make('impression');
    let s3 = make('impression');
    let s4 = make('impression');
    [s1,s2,s3,s4].forEach((s) => { model.get('impressions').pushObject(s); });
    let maximumAmount = model.allocate(s2, 5.326);
    expect(s1.get('amount')).to.eq(4.06);
    expect(maximumAmount).to.eq(5.32);
    expect(s3.get('amount')).to.eq(4.06);
    expect(s4.get('amount')).to.eq(4.06);
  });

  describe('rounding', function() {
    it('#allocate returns the maximum possible amount, floored to two decimals', function() {
      let invoice = this.subject();
      // let store = this.store();
      let s1 = make('impression', {fixed: true, amount: 3.07});
      let s2 = make('impression', {fixed: true, amount: 2.89});
      let s3 = make('impression', {fixed: true, amount: 3.00});
      let s4 = make('impression', {fixed: true, amount: 6.99});
      let s5 = make('impression', {fixed: false, amount: 0.77});
      let s6 = make('impression', {fixed: false, amount: 0.77});
      invoice.get('impressions', [s1, s2, s3, s4, s5, s6]);
      invoice.allocate(s4, 7.00);
      expect(s1.get('amount')).to.eq(3.07);
      expect(s2.get('amount')).to.eq(2.89);
      expect(s3.get('amount')).to.eq(3.00);
      expect(s4.get('amount')).to.eq(7.00);
      expect(s5.get('amount')).to.eq(0.77);
      expect(s6.get('amount')).to.eq(0.77);
    });
  });
});
