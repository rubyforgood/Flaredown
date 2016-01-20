import Ember from 'ember';
import ToriiAuthenticator from 'ember-simple-auth/authenticators/torii';

export default ToriiAuthenticator.extend({
  ajax: Ember.inject.service(),
  torii: Ember.inject.service(),

  restore: function(data) {
    var resolveData = data || {};
    this._provider = resolveData.provider;
    return new Ember.RSVP.Promise(function(resolve) { resolve(resolveData); });
  },

  authenticate() {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this._super('facebook-connect').then( (data) => {
        this.get('ajax').request('/api/auth/facebook/callback', {
          method: 'POST',
          dataType: 'json'
        }).then((response) => {
          resolve({
            // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
            user_id: response.user_id,
            // jscs:enable requireCamelCaseOrUpperCaseIdentifiers
            email: response.email,
            token: response.token,
            provider: data.provider
          });
        }, reject);
      }, reject);
    });
  }
});
