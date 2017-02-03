import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

const {
  set,
  Component,
} = Ember;

export default Component.extend(CheckinByDate, {
  journalIsVisible: false,

  actions: {
    routeToCheckin(date) {
      this.routeToCheckin(date);
    },

    showJournal() {
      set(this, 'journalIsVisible', true);
    },

    showChart() {
      set(this, 'journalIsVisible', false);
    },
  },
});
