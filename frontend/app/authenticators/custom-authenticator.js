import Ember from 'ember';

import Base from 'auth0-ember-simple-auth/authenticators/lock';

export default Base.extend({
  authenticate (options) {
    return new Ember.RSVP.Promise((res) => {
      this.get('lock').show(options, (err, profile, jwt, accessToken, state, refreshToken) => {
        if (err) {
          this.onAuthError(err);
        } else {
          var sessionData = { profile, jwt, accessToken, refreshToken, state };
          this.afterAuth(sessionData).then(response => res(this._setupFutureEvents(response)));
        }
      });
    });
  },
});
