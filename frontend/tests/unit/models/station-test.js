import { moduleForModel, test } from 'ember-qunit';

moduleForModel('station', 'Unit | Model | station', {
  // Specify the other units that are required for this test.
  needs: ['model:medium']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
