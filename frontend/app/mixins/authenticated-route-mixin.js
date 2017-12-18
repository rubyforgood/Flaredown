import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Mixin.create(AuthenticatedRouteMixin, {

  init() {
    this._super(...arguments);

    if(this.get('session.fullStoryInitialized') === false) {
      this.setFullStoryUser();
    }
  },

  setFullStoryUser() {
    let currentUser = this.get('session.currentUser');
    if (Ember.isPresent(currentUser)) {
      currentUser.then( user => {
        if (Ember.isPresent(window.FS)) {
          window.FS.identify(user.get('id'));
          this.set('session.fullStoryInitialized', true);
        }
      });
    }
  },

  notifyPageChange() {
    Ember.run.scheduleOnce('afterRender', this, () => {
      this.androidPageChange();
    });
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
