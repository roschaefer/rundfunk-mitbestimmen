import { expect } from 'chai';
import { describe, it } from 'mocha';
import Object from '@ember/object';
import ResetScrollPositionMixin from 'frontend/mixins/reset-scroll-position';

describe('Unit | Mixin | reset scroll position', function() {
  // Replace this with your real tests.
  it('works', function() {
    let ResetScrollPositionObject = Object.extend(ResetScrollPositionMixin);
    let subject = ResetScrollPositionObject.create();
    expect(subject).to.be.ok;
  });
});
