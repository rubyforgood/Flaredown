import Ember from 'ember';

const {
  set,
  Component,
  inject: { service },
  computed: { alias },
  setProperties,
} = Ember;

export default Component.extend({
  patternsVisible: false,
  chartVisible: true,
  journalIsVisible: alias('chartJournalSwitcher.journalIsVisible'),
  chartJournalSwitcher: service(),
  i18n: service(),

  actions: {
    routeToCheckin(date) {
      this.routeToCheckin(date);
    },

    showJournal() {
      setProperties(this, { journalIsVisible: true, chartVisible: false, patternsVisible: false });
    },

    showChart() {
      set(this, 'journalIsVisible', false);
      setProperties(this, { journalIsVisible: false, chartVisible: true, patternsVisible: false });
    },

    showPatterns() {
      setProperties(this, { journalIsVisible: false, chartVisible: false, patternsVisible: true });
    },
  },
});
