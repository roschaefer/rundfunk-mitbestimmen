import Ember from 'ember';
import { expect } from 'chai';
import { describe, it, beforeEach } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';

describe('Unit | Model | user', function() {
  setupModelTest('user', {
    // Specify the other units that are required for this test.
      needs: []
  });
  beforeEach(function(){
    manualSetup(this.container);
  });

  // Replace this with your real tests.
  it('exists', function() {
    let model = this.subject();
    // var store = this.store();
    expect(model).to.be.ok;
  });

  describe('hasLocation', function(){
    it('true if user has coordinates', function() {
      let user = make('user', {
        latitude: 23,
        longitude: 24
      });
      expect(user.get('hasLocation')).to.be.true;
    });
  });

  describe('coordinates', function(){
    it('updates latitude/longitude', function() {
      let user = make('user');
      Ember.run(function() {
        user.set('coordinates', [23, 24]);
      });
      expect(user.get('latitude')).to.eq(23);
      expect(user.get('longitude')).to.eq(24);
    });
  })
});
