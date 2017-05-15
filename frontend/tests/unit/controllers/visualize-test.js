import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:visualize', 'Unit | Controller | visualize', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
  needs: [
    'service:session',
    'service:intl',
    'service:metrics',
    'ember-metrics@metrics-adapter:piwik', // bundled adapter
  ]
});

// Replace this with your real tests.
test('it exists', function(assert) {
  let controller = this.subject();
  assert.ok(controller);
});
