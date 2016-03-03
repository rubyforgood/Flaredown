import Ember from 'ember';

export default Ember.Component.extend({
  classNames: 'navigation-bar',

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
    },

    openEditProfileModal() {
      this.get('session.currentUser.profile').then( (profile) => {
        Ember.getOwner(this).lookup('route:application').send('openModal', 'modals/edit-profile', profile);
      });
    },

    openChangePasswordModal() {
      this.store.find('password', 1).then( (password) => {
        Ember.getOwner(this).lookup('route:application').send('openModal', 'modals/change-password', password);
      })

    },

  }

});
