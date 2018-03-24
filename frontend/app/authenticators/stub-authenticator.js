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
        expiresIn: 60 * 60, // one hour is more than enough for one fullstack test
        idTokenPayload: {
          // iat is short for "issued at" in seconds
          iat: Math.ceil(Date.now() / 1000),
        }
      };
      res(sessionData);
    });
  },
});
