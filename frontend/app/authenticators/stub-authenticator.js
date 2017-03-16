import Ember from 'ember';
import Base from 'auth0-ember-simple-auth/authenticators/lock';
export default Base.extend({

  authenticate (options) {
    return new Ember.RSVP.Promise((res) => {
      const jwt = window.stubbedJwt;
      const state = options.authParams.state;
      var sessionData = { jwt, state };
      this.afterAuth(sessionData).then(response => res(this._setupFutureEvents(response)));
    });
  },
});
