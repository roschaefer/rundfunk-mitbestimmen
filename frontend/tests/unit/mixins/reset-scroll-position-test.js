import { expect } from 'chai';
import { describe, it } from 'mocha';
import Ember from 'ember';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

describe('Unit | Mixin | reset scroll position', function() {
  // Replace this with your real tests.
  it('works', function() {
    let ResetScrollPositionObject = Ember.Object.extend(ResetScrollPositionMixin);
    let subject = ResetScrollPositionObject.create();
    expect(subject).to.be.ok;
  });
});
