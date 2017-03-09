import { moduleForModel, test } from 'ember-qunit';

moduleForModel('format', 'Unit | Model | format', {
  // Specify the other units that are required for this test.
  needs: ['model:broadcast']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
