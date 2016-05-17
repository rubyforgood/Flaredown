import Ember from 'ember';
import SessionService from 'ember-simple-auth/services/session';

export default SessionService.extend({
  dataStore: Ember.inject.service('store'),

  userId: Ember.computed.alias('session.authenticated.user_id'),
  email: Ember.computed.alias('session.authenticated.email'),
  token: Ember.computed.alias('session.authenticated.token'),

  notificationChannel: Ember.computed.alias('extraSession.notificationChannel'),

  discourseUrl: Ember.computed.alias('extraSession.discourseUrl'),
  discourseEnabled: Ember.computed.alias('extraSession.discourseEnabled'),

  setCurrentUser: Ember.on('init', Ember.observer('isAuthenticated', function() {
    var userId = this.get('userId');
    if (Ember.isPresent(userId)) {
      this.set('currentUser', this.get('dataStore').find('user', userId));
    } else {
      this.set('currentUser', null);
    }
  })),

  setExtraSession: Ember.on('init', Ember.observer('currentUser', function() {
    this.set('extraSession', this.get('dataStore').find('session', 1));
  })),

  intercom: Ember.inject.service(),
  setIntercomUser: Ember.on('init', Ember.observer('currentUser', function() {
    let currentUser = this.get('currentUser');
    if (Ember.isPresent(currentUser)) {
      currentUser.then( user => {
        user.get('profile').then( profile => {
          this.get('intercom').boot({
            user_hash: user.get('intercomHash'),
            email: user.get('email'),
            created_at: user.get('createdAt'),
            country_code: profile.get('country.id'),
            sex: profile.get('sex.id'),
            birth_date: profile.get('birthDate'),
            education_level: profile.get('educationLevel.id'),
            onboarded: profile.get('isOnboarded')
          });
        });
      });
    }
  }))

});
