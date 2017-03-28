import Ember from 'ember';
import Base from 'ember-simple-auth/authenticators/base';

export default Base.extend({
  restore(data) {
    return Ember.RSVP.resolve(data);
  },
  authenticate(options) {
    return new Ember.RSVP.Promise((resolve) => {
      const idToken = window.stubbedJwt;
      const state = options.auth.params.state;
      const sessionData =  {
        idToken,
        idTokenPayload: {
          "exp": 42, // the authorizer just wants a number
        },
        state
      };
      resolve(sessionData);
    });
  },
});
