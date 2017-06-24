import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupComponentTest } from 'ember-mocha';

describe('Unit | Component | invoice item amount', function() {
  setupComponentTest('invoice-item-amount', {
    // Specify the other units that are required for this test
    // needs: ['component:foo', 'helper:bar'],
    unit: true
  });

  describe('sanitize amount', function() {
    it('turns commas into dots', function() {
      let component = this.subject();
      let sanitizedAmount = component.get('sanitizeAmount')('3,5');
      expect(sanitizedAmount).to.eq(3.5);
    });

    it('removes characters', function() {
      let component = this.subject();
      let sanitizedAmount = component.get('sanitizeAmount')('3,hello5');
      expect(sanitizedAmount).to.eq(3.5);
    });
  });
});
