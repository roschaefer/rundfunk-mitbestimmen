import { resolve, Promise } from 'rsvp';
import Base from 'ember-simple-auth/authenticators/base';

export default Base.extend({
  restore(data) {
    return resolve(data);
  },
  authenticate() {
    return new Promise((res) => {
      const idToken = window.stubbedJwt;
      const sessionData =  {
        idToken,
        idTokenPayload: {
          "exp": 42, // the authorizer just wants a number
        }
      };
      res(sessionData);
    });
  },
});
