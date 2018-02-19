import { resolve, Promise } from 'rsvp';
import Base from 'ember-simple-auth/authenticators/base';

export default Base.extend({
  restore(data) {
    return resolve(data);
  },
  authenticate(_, options) {
    return new Promise((resolve) => {
      const idToken = window.stubbedJwt;
      const state = options.authParams.state;
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
