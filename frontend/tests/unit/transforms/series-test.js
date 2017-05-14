import { moduleFor, test } from 'ember-qunit';

moduleFor('transform:series', 'Unit | Transform | series', {
  // Specify the other units that are required for this test.
  // needs: ['serializer:foo']
});

// Replace this with your real tests.
test('parses array of strings to floats', function(assert) {
  let transform = this.subject();
  let serialized = [
    { "name":"Actual distribution", "data":["12.0","10.0","13.0"] },
    { "name":"Random expectation", "data":["10.0","15.0","10.0"] }
  ];
  let deserialized = transform.deserialize(serialized);
  assert.strictEqual(deserialized[0]['data'][0], 12.0);
});
