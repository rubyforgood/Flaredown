import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

const {
  set,
  Component,
  inject: { service },
  computed: { alias },
} = Ember;

export default Component.extend(CheckinByDate, {
  journalIsVisible: alias('chartJournalSwitcher.journalIsVisible'),
  chartJournalSwitcher: service(),
  i18n: service(),

  createPatternStep: false,

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

    toggleCreatePatternStep() {
      set(this, 'createPatternStep', true);
    },
  },
});
