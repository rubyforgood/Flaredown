import Ember from 'ember';
import SessionService from 'ember-simple-auth/services/session';

export default SessionService.extend({
  dataStore: Ember.inject.service('store'),

  userId: Ember.computed.alias('session.authenticated.user_id'),
  email: Ember.computed.alias('session.authenticated.email'),
  token: Ember.computed.alias('session.authenticated.token'),

  settings: Ember.computed.alias('session.authenticated.settings'),

  notificationChannel: Ember.computed.alias('settings.notificationChannel'),

  discourseUrl: Ember.computed.alias('settings.discourseUrl'),
  discourseEnabled: Ember.computed.alias('settings.discourseEnabled'),

  currentUser: Ember.computed('isAuthenticated', function() {
    if (this.get('isAuthenticated')) {
      return this.get('dataStore').find('user', this.get('session.authenticated.user_id'));
    } else {
      return null;
    }
  }),

  isUserengageSet: false,
  userengage: Ember.inject.service(),
  setupUserengage: Ember.on('init', Ember.observer('currentUser', function() {
    let currentUser = this.get('currentUser');
    if (Ember.isPresent(currentUser)) {
      currentUser.then( user => {
        user.get('profile').then( profile => {
          this.get('userengage').initialize({
            state: 'simple',
            email: user.get('email'),
            sex: profile.get('sex.id'),
            country_code: profile.get('country.id'),
            birth_date: profile.get('birthDate'),
            education_level: profile.get('educationLevel.id'),
            onboarded: profile.get('isOnboarded')
          });
          this.set('isUserengageSet', true);
        });
      });
    } else {
      if (this.get('isUserengageSet')) {
        this.get('userengage').destroy();
        this.set('isUserengageSet', false);
      }
    }
  })),

  setFullStoryUser: Ember.on('init', Ember.observer('currentUser', function() {
    let currentUser = this.get('currentUser');
    if (Ember.isPresent(currentUser)) {
      currentUser.then( user => {
        if (Ember.isPresent(window.FS)) {
          window.FS.identify(user.get('id'));
        }
      });
    }
  })),

  isMobileDevice: Ember.computed(function() {
    return /iPad|iPhone|iPod|Android/.test(navigator.userAgent);
  })

});
