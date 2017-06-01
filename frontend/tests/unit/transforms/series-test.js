import { expect } from 'chai';
import { describe, it } from 'mocha';
import { setupTest } from 'ember-mocha';

describe('Unit | Transform | series', function() {
  setupTest('transform:series', {
    // Specify the other units that are required for this test.
    // needs: ['transform:foo']
  });

  it('parses array of strings to floats', function() {
    let transform = this.subject();
    let serialized = [
      { "name":"Actual distribution", "data":["12.0","10.0","13.0"] },
      { "name":"Random expectation", "data":["10.0","15.0","10.0"] }
    ];
    let deserialized = transform.deserialize(serialized);
    expect(deserialized[0]['data'][0]).to.equal(12.0);
  });
});
