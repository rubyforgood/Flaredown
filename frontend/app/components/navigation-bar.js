import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';
import OpenProfileModal from 'flaredown/mixins/open-profile-modal';

export default Ember.Component.extend(CheckinByDate, OpenProfileModal, {
  classNames: 'navigation-bar',

  didInsertElement() {
    this._super(...arguments);
    this.installHandlers();
  },

  installHandlers() {
    this.$('#js-navigation-menu').removeClass("show");
    this.$('.sliding-panel-button,.sliding-panel-fade-screen').on('click touchstart', (e) => {
      this.$('.sliding-panel-content,.sliding-panel-fade-screen').toggleClass('is-visible');
      e.preventDefault();
    });
  },

  hideSlidingPanel() {
    this.$('.sliding-panel-content,.sliding-panel-fade-screen').removeClass('is-visible');
  },

  actions: {
    invalidateSession() {
      this.hideSlidingPanel();
      this.get('session').invalidate();
    },

    openEditProfileModal() {
      this.hideSlidingPanel();
      this.openProfileModal();
    },

    openChangePasswordModal() {
      this.hideSlidingPanel();
      this.store.find('password', 1).then( (password) => {
        Ember.getOwner(this).lookup('route:application').send('openModal', 'modals/change-password', password);
      });
    },

    goToTodaysCheckin() {
      this.hideSlidingPanel();
      this.routeToCheckin(moment(new Date()).format("YYYY-MM-DD"));
    },

    goToChart() {
      this.hideSlidingPanel();
      this.router.transitionTo('chart');
    },

    goToDiscourse() {
      this.hideSlidingPanel();
      window.open(this.get('session.discourseUrl'), '_blank');
    }

  }

});
