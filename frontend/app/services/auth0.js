import Service from '@ember/service';
import ENV  from 'frontend/config/environment';
import { WebAuth } from 'auth0';

export default Service.extend({
  init() {
    this._super(...arguments);
    const webAuth = new WebAuth({
      domain: ENV.auth0.domain, // domain from auth0
      clientID: ENV.auth0.clientId, // clientId from auth0
      redirectUri: ENV.auth0.callbacks.login,
      audience: `https://${ENV.auth0.domain}/userinfo`,
      responseType: 'token id_token',
      scope: 'openid email' // adding profile because we want username, given_name, etc
    });
    this.set('webAuth', webAuth);
  }
});
