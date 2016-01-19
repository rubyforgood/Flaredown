import Ember from 'ember';
import FacebookOauth2 from 'torii/providers/facebook-oauth2';

export default FacebookOauth2.extend({
  session: Ember.inject.service('session'),

  name:    'facebook',
  redirectUri: Ember.computed.alias('session.extraSession.baseUrl'),
  apiKey: Ember.computed.alias('session.extraSession.facebookAppId'),
});
