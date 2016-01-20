import Ember from 'ember';
import ToriiAuthenticator from 'ember-simple-auth/authenticators/torii';

export default ToriiAuthenticator.extend({
  ajax: Ember.inject.service(),
  torii: Ember.inject.service(),


  authenticate() {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this._super('facebook-connect').then( (data) => {
        this.get('ajax').request('/api/auth/facebook/callback', {
          method: 'POST',
          dataType: 'json'
        }).then((response) => {
          resolve({
            // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
            access_token: response.access_token,
            // jscs:enable requireCamelCaseOrUpperCaseIdentifiers
            provider: data.provider
          });
        }, reject);
      }, reject);
    });
  }
});
