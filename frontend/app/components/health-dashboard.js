import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

const {
  get,
  set,
  computed,
  Component,
  inject: { service },
  computed: { alias },
} = Ember;

const STEPS = {
  INITIAL: 1,
  CREATE: 2,
  INDEX: 3
};

export default Component.extend(CheckinByDate, {
  STEPS,
  selectedPattern: null,
  currentStep: null,
  journalIsVisible: alias('chartJournalSwitcher.journalIsVisible'),
  chartJournalSwitcher: service(),
  i18n: service(),

  init() {
    this._super(...arguments);

    get(this, 'patterns').then((patterns) => {
      set(this, 'currentStep', get(patterns, 'length') > 0 ? STEPS.INDEX : STEPS.INITIAL);
    });
  },

  patterns: computed(function() {
    return DS.PromiseArray.create({
      promise: get(this, 'store').findAll('pattern')
    });
  }),

  actions: {
    create() {
      set(this, 'selectedPattern', null);
      set(this, 'currentStep', STEPS.CREATE);
    },

    edit(pattern) {
      set(this, 'selectedPattern', pattern);
      set(this, 'currentStep', STEPS.CREATE);
    },

    routeToCheckin(date) {
      this.routeToCheckin(date);
    },

    showJournal() {
      set(this, 'journalIsVisible', true);
    },

    showChart() {
      set(this, 'journalIsVisible', false);
    },

    nextStep() {
      set(this, 'currentStep', STEPS.CREATE);
    },
  },
});
