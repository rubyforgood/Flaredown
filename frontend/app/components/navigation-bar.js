/* global moment */
import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Component.extend(CheckinByDate, {
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
      });
    },

    goToTodaysCheckin() {
      this.routeToCheckin(moment(new Date()).format("YYYY-MM-DD"));
    }

  }

});
