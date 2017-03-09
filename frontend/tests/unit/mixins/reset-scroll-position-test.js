import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';
import { module, test } from 'qunit';

module('Unit | Mixin | reset scroll position');

// Replace this with your real tests.
test('it works', function(assert) {
  let ResetScrollPositionObject = Ember.Object.extend(ResetScrollPositionMixin);
  let subject = ResetScrollPositionObject.create();
  assert.ok(subject);
});
