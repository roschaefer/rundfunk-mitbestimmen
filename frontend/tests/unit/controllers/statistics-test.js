import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:statistics', 'Unit | Controller | statistics', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
  needs: [
    'service:metrics',
    'ember-metrics@metrics-adapter:piwik', // bundled adapter
  ]
});

// Replace this with your real tests.
test('it exists', function(assert) {
  let controller = this.subject();
  assert.ok(controller);
});
