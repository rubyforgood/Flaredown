import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Component.extend(CheckinByDate, {
  classNames: 'navigation-bar',

  didInsertElement() {
    this._super(...arguments);
    this.installHandlers();
  },

  installHandlers() {
    Ember.$('#js-navigation-menu').removeClass("show");

    Ember.$('.sliding-panel-button,.sliding-panel-fade-screen,.sliding-panel-close').on('click touchstart', (e) => {
      Ember.$('.sliding-panel-content,.sliding-panel-fade-screen').toggleClass('is-visible');
      e.preventDefault();
    });
  },

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
