import { run } from '@ember/runloop';
import { expect } from 'chai';
import { describe, it, beforeEach } from 'mocha';
import { setupModelTest } from 'ember-mocha';
import { make, manualSetup } from 'ember-data-factory-guy';
import moment from 'moment';

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
      run(function() {
        user.set('coordinates', [23, 24]);
      });
      expect(user.get('latitude')).to.eq(23);
      expect(user.get('longitude')).to.eq(24);
    });
  })

  describe('ageGroup', function(){
    describe('setter', function(){
      it('updates birthdate', function() {
        let user = make('user');
        let expectedMoment = new moment();
        expectedMoment = expectedMoment.subtract(2, 'years');
        expectedMoment = expectedMoment.subtract(6, 'months');
        expectedMoment = expectedMoment.startOf('day');
        user.set('ageGroup', '0-5');
        expect(user.get('birthday')).to.eq(expectedMoment);
      });

      describe('handles edge cases', function() {
        it('ageGroup < 0');
        it('ageGroup > 99');
        it('ageGroup is not a valid string');
      });
    });

    describe('getter', function(){
      it('reads from birthdate', function() {
        let twentyEightYearsOld = moment();
        twentyEightYearsOld = twentyEightYearsOld.subtract(28, 'years');
        twentyEightYearsOld = twentyEightYearsOld.startOf('day');
        let user = make('user', {birthday: twentyEightYearsOld.toDate()});
        expect(user.get('ageGroup')).to.eq('25-29');
      });

      describe('handles edge cases', function() {
        it('birthday in future');
        it('birthday in 1900');
        it('birthday is on the lower edge of an ageGroup, e.g. 29');
        it('birthday is on the upper edge of an ageGroup, e.g. 25');
      });
    });

  })
});
