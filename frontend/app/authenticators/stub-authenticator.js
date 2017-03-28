import Ember from 'ember';
import Base from 'ember-simple-auth/authenticators/base';

export default Base.extend({
  authenticate(options) {
    return new Ember.RSVP.Promise((resolve) => {
      const idToken = window.stubbedJwt;
      const state = options.auth.params.state;
      const sessionData = {idToken, state };
      resolve(sessionData);
    });
  },
});
