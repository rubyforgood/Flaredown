import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Mixin.create(AuthenticatedRouteMixin, {

  init() {
    this._super(...arguments);
    if(this.get('session.userEngageInitialized') === false) {
      this.setUserEngage();
    }
    if(this.get('session.fullStoryInitialized') === false) {
      this.setFullStoryUser();
    }
  },

  setUserEngage() {
    let currentUser = this.get('session.currentUser');
    if (Ember.isPresent(currentUser)) {
      currentUser.then( user => {
        user.get('profile').then( profile => {
          this.get('session.userEngage').initialize({
            state: 'simple',
            email: user.get('email'),
            sex: profile.get('sex.id'),
            country_code: profile.get('country.id'),
            birth_date: profile.get('birthDate'),
            education_level: profile.get('educationLevel.id'),
            onboarded: profile.get('isOnboarded')
          });
          this.set('session.isUserengageSet', true);
        });
      });
    }
  },

  setFullStoryUser() {
    let currentUser = this.get('session.currentUser');
    if (Ember.isPresent(currentUser)) {
      currentUser.then( user => {
        if (Ember.isPresent(window.FS)) {
          window.FS.identify(user.get('id'));
        }
      });
    }
  },

  notifyPageChange() {
    Ember.run.scheduleOnce('afterRender', this, () => {
      this.userengagePageChange();
      this.androidPageChange();
    });
  },

  userengagePageChange() {
    if (this.get('session.userEngageInitialized')) {
      this.get('userengage').pageHit();
    }
  },

  androidPageChange() {
    if (Ember.isPresent(window.AndroidInterface)) {
      window.AndroidInterface.pageChanged(document.location.href);
    }
  },

  actions: {
    didTransition() {
      this.notifyPageChange();
      this._super();
    }
  }

});
