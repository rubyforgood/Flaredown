import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';
import DatesRetriever from 'flaredown/mixins/chart/dates-retriever';
import DS from 'ember-data';
import moment from 'moment';

const {
  get,
  set,
  computed,
  computed: { alias },
  Component,
  inject: { service },
  setProperties,
} = Ember;

const STEPS = {
  INITIAL: 1,
  CREATE: 2,
  INDEX: 3
};

export default Component.extend(CheckinByDate, DatesRetriever, {
  i18n: service(),
  patternsLoading: service(),

  STEPS,
  selectedPattern: null,
  currentStep: null,
  dateRange: 2,
  serieHeight: 75,
  loadingPatterns: alias('patternsLoading.loadingPatterns'),

  patterns: computed(function() {
    return DS.PromiseArray.create({
      promise: get(this, 'store').findAll('pattern')
    });
  }),

  /*eslint-disable no-dupe-keys*/
  currentStep: computed('patterns.length', function(){
    return get(this, 'patterns.length') > 0 ? STEPS.INDEX : STEPS.INITIAL;
  }),
  /*eslint-enable no-dupe-keys*/

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
      setProperties(this, { selectedPattern: null, currentStep: STEPS.CREATE });
    },

    edit(pattern) {
      setProperties(this, { selectedPattern: pattern, currentStep: STEPS.CREATE });
    },

    requestData(page) {
      get(this, 'store').query('pattern', { page: page }).then((record) => {
        get(this, 'patterns').toArray().pushObject(record);
        set(this, 'loadingPatterns', false);
      })
    },

    nextStep() {
      set(this, 'currentStep', STEPS.CREATE);
    },
  },
});
