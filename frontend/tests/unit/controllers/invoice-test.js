import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:invoice', 'Unit | Controller | invoice', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
  needs: [
    'service:session',
    'service:metrics',
    'ember-metrics@metrics-adapter:piwik', // bundled adapter
  ]
});

// Replace this with your real tests.
test('it exists', function(assert) {
  let controller = this.subject();
  assert.ok(controller);
});
