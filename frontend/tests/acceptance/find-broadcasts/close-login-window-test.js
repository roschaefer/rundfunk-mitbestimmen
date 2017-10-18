import { describe, it, beforeEach, afterEach } from 'mocha';
import { expect } from 'chai';
import startApp from '../helpers/start-app';
import destroyApp from '../helpers/destroy-app';

describe('Acceptance | find broadcasts/close login window', function() {
  let application;

  beforeEach(function() {
    application = startApp();
  });

  afterEach(function() {
    destroyApp(application);
  });

  it('can visit /find-broadcasts/close-login-window', function() {
    visit('/find-broadcasts/close-login');

    return andThen(() => {
      expect(currentURL()).to.equal('/find-broadcasts/close-login-window');
    });
  });
});
