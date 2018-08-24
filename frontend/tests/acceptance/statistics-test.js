import { describe, it, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from 'frontend/tests/helpers/start-app';
import destroyApp from 'frontend/tests/helpers/destroy-app';

describe('Acceptance | statistics', function() {
  let application;

  beforeEach(function() {
    application = startApp();
  });

  afterEach(function() {
    destroyApp(application);
  });

  it('can visit /statistics', function() {
    visit('/statistics');

    return andThen(() => {
      expect(currentURL()).to.equal('/statistics');
    });
  });
});
