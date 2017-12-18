import Ember from 'ember';
import SessionService from 'ember-simple-auth/services/session';

const {
  observer,
} = Ember;

export default SessionService.extend({
  /*
   * Services
   */
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

  fullStoryInitialized: false,

  isMobileDevice: Ember.computed(function() {
    return /iPad|iPhone|iPod|Android/.test(navigator.userAgent);
  }),

  actualUser: null,

  actualUserObserver: observer('isAuthenticated', function() {
    if (this.get('isAuthenticated')) {
      this.get('dataStore').find('user', this.get('session.authenticated.user_id')).then((user) => {
        this.set('actualUser', user);
      });
    } else {
      this.set('actualUser', null);
    }
  }),
});
