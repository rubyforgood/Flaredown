import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

const {
  get,
  computed,
  Component,
  inject: {
    service,
  },
} = Ember;

export default Component.extend(CheckinByDate, {
  classNames: ['bottom-nav'],

  notifications: service(),

  isCheckinPath: computed('router.url', function() {
    return get(this, 'router.url').split('/')[1] === 'checkin';
  }),

  checkinNavClass: computed('isCheckinPath', function() {
    return `bottom-link ${get(this, 'isCheckinPath') ? 'active' : ''}`;
  }),
});
