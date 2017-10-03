import Ember from 'ember';

const {
  get,
  set,
  computed,
  observer,
  Mixin,
  getProperties,
  setProperties,
  run: {
    debounce,
    scheduleOnce,
  },
  inject: {
    service,
  },
  computed: {
    alias,
  },
} = Ember;

export default Mixin.create({
  chartsVisibilityService: service('charts-visibility'),

  patternIncludes : alias('chartsVisibilityService.patternIncludes'),

  checkins: [],
  trackables: [],

  isChartEnablerDisabled: computed('patternIncludes.length', function() {
    return get(this, 'patternIncludes.length') === 0;
  }),

  setChartsData() {
    const tags = this.store.peekAll('tag').toArray();
    const foods = this.store.peekAll('food').toArray();
    const checkins = this.peekSortedCheckins();
    const symptoms = this.store.peekAll('symptom').toArray();
    const conditions = this.store.peekAll('condition').toArray();
    const treatments = this.store.peekAll('treatment').toArray();
    const harveyBradshawIndices = this.store.peekAll('harveyBradshawIndex').toArray();
    const trackables = [...conditions, ...symptoms, ...treatments, ...tags, ...foods, ...harveyBradshawIndices];

    return this.isDestroyed || setProperties(this, {checkins, trackables});
  },

  peekSortedCheckins() {
    return this
      .store
      .peekAll('checkin')
      .toArray()
      .sort(
        (a, b) => moment(get(a, 'date')).diff(get(b, 'date'), 'days')
      );
  },
});
