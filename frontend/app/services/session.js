import Ember from 'ember';
import SessionService from 'ember-simple-auth/services/session';

export default SessionService.extend({
  dataStore: Ember.inject.service('store'),

  userId: Ember.computed.alias('session.authenticated.user_id'),

  setCurrentUser: Ember.on('init', Ember.observer('isAuthenticated', function() {
    var userId = this.get('userId');
    if (Ember.isPresent(userId)) {
      this.set('currentUser', this.get('dataStore').find('user', userId));
    } else {
      this.set('currentUser', null);
    }
  })),

  setExtraSession: Ember.on('init', Ember.observer('currentUser', function() {
    this.get('dataStore').find('session', 1).then( (session) => {
      this.set('extraSession', session);
    });
  })),

  getCurrentUser() {
    return Ember.RSVP.resolve(this.get('currentUser'));
  }

});
