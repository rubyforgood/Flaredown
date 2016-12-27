import Ember from 'ember';
import OpenProfileModal from 'flaredown/mixins/open-profile-modal';

export default Ember.Component.extend(OpenProfileModal, {
  classNames: ['bottom-nav'],

  isCheckinPath: Ember.computed('router.url', function() {
    return this.get('router.url').split('/')[1] === 'checkin';
  }),

  checkinNavClass: Ember.computed('isCheckinPath', function() {
    return `bottom-link ${this.get('isCheckinPath') ? 'active' : ''}`;
  }),

  actions: {
    openSettings() {
      this.openProfileModal();
    },
  },
});
