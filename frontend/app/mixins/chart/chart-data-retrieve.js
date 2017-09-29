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

  hiddenCharts: alias('chartsVisibilityService.hiddenCharts'),
  visibilityFilter: alias('chartsVisibilityService.visibilityFilter'),

  updateTrackables: observer(
    'centeredDate',
    'chartLoaded',
    'chartsVisibilityService.payload.tags.@each.visible',
    'chartsVisibilityService.payload.foods.@each.visible',
    'chartsVisibilityService.payload.symptoms.@each.visible',
    'chartsVisibilityService.payload.conditions.@each.visible',
    'chartsVisibilityService.payload.treatments.@each.visible',
    'chartsVisibilityService.payload.weathersMeasures.@each.visible',
    'chartsVisibilityService.payload.harveyBradshawIndices.@each.visible',
    function() {
      debounce(this, this.fetchDataChart, 1000);
    }
  ),

  checkins: [],
  trackables: [],

  isChartEnablerDisabled: computed('hiddenCharts.length', function() {
    return get(this, 'hiddenCharts.length') === 0;
  }),

  // endAtWithCache: computed('endAt', function() {
  //   return moment(get(this, 'endAt')).add(get(this, 'daysRadius'), 'days');
  // }),

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
