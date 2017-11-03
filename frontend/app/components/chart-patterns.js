import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';
import DatesRetriever from 'flaredown/mixins/chart/dates-retriever';
import DS from 'ember-data';

const {
  get,
  set,
  computed,
  observer,
  Component,
  inject: { service },
} = Ember;

const STEPS = {
  INITIAL: 1,
  CREATE: 2,
  INDEX: 3
};

export default Component.extend(CheckinByDate, DatesRetriever, {
  STEPS,
  selectedPattern: null,
  currentStep: null,
  i18n: service(),
  dateRange: 2,
  serieHeight: 75,

  patterns: computed(function() {
    return DS.PromiseArray.create({
      promise: get(this, 'store').findAll('pattern')
    });
  }),

  currentStep: computed('patterns.length', function(){
    return get(this, 'patterns.length') > 0 ? STEPS.INDEX : STEPS.INITIAL;
  }),

  checkins: computed(function() {
    return this
      .store
      .peekAll('checkin')
      .toArray()
      .sort(
        (a, b) => moment(get(a, 'date')).diff(get(b, 'date'), 'days')
      );
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

    requestData(page) {
      get(this, 'store').query('pattern', { page: page }).then((record) => {
        get(this, 'patterns').toArray().pushObject(record);
      })
    },

    nextStep() {
      set(this, 'currentStep', STEPS.CREATE);
    },
  },
});
