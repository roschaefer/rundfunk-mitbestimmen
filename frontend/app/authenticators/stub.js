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
          // iat is short for "issued at" in seconds
          iat: Math.ceil(Date.now() / 1000),
          exp: 999999999999999 // do not expire in the near future
        }
      };
      res(sessionData);
    });
  },
});
