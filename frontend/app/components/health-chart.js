import Ember from 'ember';
import Resizable from './chart/resizable';
import FieldsByUnits from 'flaredown/mixins/fields-by-units';

const {
  get,
  set,
  RSVP,
  computed,
  observer,
  Component,
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

export default Component.extend(Resizable, FieldsByUnits, {
  chartSelectedDates: service(),

  classNames: ['health-chart'],

  checkins: [],
  trackables: [],
  flatHeight: 30,
  serieHeight: 75,
  seriePadding: 20,
  pixelsPerDate: 32,
  timelineHeight: 25,
  lastChartOffset: 0,
  lastChartHeight: 0,

  centeredDate: alias('chartSelectedDates.centeredDate'),
  hiddenCharts: alias('chartsVisibilityService.hiddenCharts'),
  pressureUnits: alias('session.currentUser.profile.pressureUnits'),
  timelineLength: alias('timeline.length'),
  visibilityFilter: alias('chartsVisibilityService.visibilityFilter'),

  updateTrackables: observer(
    'centeredDate',
    'chartLoaded',
    'chartsVisibilityService.payload.tags.@each.visible',
    'chartsVisibilityService.payload.symptoms.@each.visible',
    'chartsVisibilityService.payload.conditions.@each.visible',
    'chartsVisibilityService.payload.treatments.@each.visible',
    'chartsVisibilityService.payload.weathersMesures.@each.visible',
    function() {
      debounce(this, this.fetchDataChart, 1000);
    }
  ),

  showChart: observer('chartToShow', function() {
    const { chartToShow, chartsVisibilityService } = getProperties(this, 'chartToShow', 'chartsVisibilityService');

    chartsVisibilityService.setVisibility(true, chartToShow.category, chartToShow.label);
  }),

  isChartEnablerDisabled: computed('hiddenCharts.length', function() {
    return get(this, 'hiddenCharts.length') === 0;
  }),

  chartEnablerPlaceholder: computed('isChartEnablerDisabled', function() {
    return get(this, 'isChartEnablerDisabled') ? "No charts to add" : "Add a chart";
  }),

  daysRadius: computed('SVGWidth', function() {
    return Math.ceil(get(this, 'SVGWidth') / (get(this, 'pixelsPerDate') * 2));
  }),

  endAt: computed('daysRadius', 'centeredDate', function() {
    const centeredDate = get(this, 'centeredDate');

    if (centeredDate) {
      return moment(centeredDate).add(get(this, 'daysRadius'), 'days');
    } else {
      return moment();
    }
  }),

  startAt: computed('daysRadius', 'centeredDate', function() {
    const daysRadius = get(this, 'daysRadius');
    const centeredDate = get(this, 'centeredDate');

    if (centeredDate) {
      return moment(centeredDate).subtract(daysRadius, 'days');
    } else {
      return moment().subtract(daysRadius * 2, 'days');
    }
  }),

  startAtWithCache: computed('startAt', function() {
    return moment(get(this, 'startAt')).subtract(get(this, 'daysRadius'), 'days');
  }),

  endAtWithCache: computed('endAt', function() {
    return moment(get(this, 'endAt')).add(get(this, 'daysRadius'), 'days');
  }),

  seriesLength: computed('series.weathersMesures.length', 'trackables.length', function() {
    return get(this, 'trackables.length') + get(this, 'series.weathersMesures.length');
  }),

  seriesWidth: computed('SVGWidth', function() {
    return get(this, 'SVGWidth') * 2;
  }),

  totalSeriesHeight: computed('lastChartOffset', 'lastChartHeight', function() {
    const {
      lastChartOffset,
      lastChartHeight,
      seriePadding,
    } = getProperties(this, 'lastChartOffset', 'lastChartHeight', 'seriePadding');

    return lastChartOffset + lastChartHeight + seriePadding;
  }),

  timeline: computed('checkins', 'startAt', 'endAt', function() {
    let timeline = Ember.A();

    moment.range(get(this, 'startAtWithCache'), get(this, 'endAtWithCache')).by('days', function(day) {
      timeline.pushObject(
        d3.time.format('%Y-%m-%d').parse(day.format("YYYY-MM-DD"))
      );
    });

    return timeline;
  }),

  SVGHeight: computed('timelineLength', 'totalSeriesHeight', function() {
    if(Ember.isPresent(get(this, 'totalSeriesHeight'))) {
      return get(this, 'totalSeriesHeight') + get(this, 'timelineHeight') + get(this, 'seriePadding');
    } else {
      return get(this, 'timelineHeight') + get(this, 'seriePadding');
    }
  }),

  SVGWidth: computed('checkins',function() {
    return this.$().width();
  }),

  observeFilterAndTrackables: observer(
    'trackables',
    'pressureUnits',
    'chartsVisibilityService.payload.tags.@each.visible',
    'chartsVisibilityService.payload.symptoms.@each.visible',
    'chartsVisibilityService.payload.conditions.@each.visible',
    'chartsVisibilityService.payload.treatments.@each.visible',
    'chartsVisibilityService.payload.weathersMesures.@each.visible',
    function() {
      const {
        flatHeight,
        serieHeight,
        seriePadding,
        visibilityFilter,
      } = getProperties(this, 'flatHeight', 'serieHeight', 'seriePadding', 'visibilityFilter');

      let lastChartHeight = serieHeight;
      let chartOffset = 0 - lastChartHeight - seriePadding;
      let series = this.seriesWithBlanks(
        this.unpositionedSeries(visibilityFilter),
        visibilityFilter
      );

      series.conditions.forEach(item => {
        item.chartOffset = chartOffset += lastChartHeight + seriePadding;
      });

      series.symptoms.forEach(item => {
        item.chartOffset = chartOffset += lastChartHeight + seriePadding;
      });

      series.treatments.forEach((item, index) => {
        item.chartOffset = chartOffset += (index === 0 ? serieHeight : flatHeight) + seriePadding;
      });

      series.tags.forEach((item, index) => {
        let previousHeight = series.treatments.length === 0 && index === 0 ? serieHeight : flatHeight;

        item.chartOffset = chartOffset += previousHeight + seriePadding;
      });

      if (series.treatments.length || series.tags.length) {
        lastChartHeight = flatHeight;
      }

      const weatherCategory = visibilityFilter.weathersMesures;

      if (weatherCategory && weatherCategory['Avg daily humidity']) {
        series.weathersMesures.pushObject({
          name: 'Avg daily humidity',
          unit: '%',
          field: 'humidity',
          chartOffset: chartOffset += lastChartHeight + seriePadding,
        });

        lastChartHeight = serieHeight;
      }

      if (weatherCategory && weatherCategory['Avg daily atmospheric pressure']) {
        series.weathersMesures.pushObject({
          name: 'Avg daily atmospheric pressure',
          unit: get(this, 'pressureUnits'),
          field: this.pressureFieldByUnits(get(this, 'pressureUnits')),
          chartOffset: chartOffset += lastChartHeight + seriePadding,
        });

        lastChartHeight = serieHeight;
      }

      set(this, 'series', series);
      set(this, 'lastChartOffset', chartOffset);
      set(this, 'lastChartHeight', lastChartHeight);
    }
  ),

  unpositionedSeries(visibilityFilter) {
    let series = {
      conditions: [],
      symptoms:   [],
      treatments: [],
      tags: [],
      weathersMesures: [],
    };

    get(this, 'trackables').forEach(item => {
      let name = get(item, 'name');
      let category = get(item, 'constructor.modelName').pluralize();
      let visibleCategory = visibilityFilter[category];

      if (visibleCategory && visibleCategory[name]) {
        series[category].pushObject({ chartOffset: 0, model: item });
      }
    });

    return series;
  },

  seriesWithBlanks(series, visibilityFilter) {
    let result = {
      conditions: [],
      symptoms:   [],
      treatments: [],
      tags: [],
      weathersMesures: [],
    };

    Object.keys(visibilityFilter).forEach(categoryName => {
      const category = get(visibilityFilter, categoryName);

      Object.keys(category).forEach(chartName => {
        if (category[chartName]) {
          const chartFromSeries = series[categoryName].length && series[categoryName].findBy('model.name', chartName);

          result[categoryName].pushObject(chartFromSeries || {
            blank: true,
            chartOffset: 0,
            model: Ember.Object.create({
              name: chartName,
              fillClass: 'colorable-fill-35',
              strokeClass: 'colorable-stroke-35',
            }),
          });
        }
      });
    });

    return result;
  },

  didInsertElement() {
    this._super(...arguments);

    scheduleOnce('afterRender', this, () => {
      this.fetchDataChart().then(() => {
        return this.isDestroyed || set(this, 'chartLoaded', true);
      });
    });
  },

  fetchDataChart() {
    const { endAt, startAt } = getProperties(this, 'endAt', 'startAt');

    const checkins = this.peekSortedCheckins();

    if (
      checkins.length &&
      endAt.isSameOrBefore(checkins.get('lastObject.date'), 'day') &&
      startAt.isSameOrAfter(checkins.get('firstObject.date'), 'day')
    ) {
      return new RSVP.Promise((resolve) => {
        resolve(this.setChartsData());
      });
    } else {
      const { endAtWithCache, startAtWithCache } = getProperties(this, 'endAtWithCache', 'startAtWithCache');

      return this
        .store
        .queryRecord('chart', {
          id: 'health',
          end_at: endAtWithCache.format("YYYY-MM-DD"),
          start_at: startAtWithCache.format("YYYY-MM-DD"),
        })
        .then(() => this.setChartsData());
    }
  },

  setChartsData() {
    const tags = this.store.peekAll('tag').toArray();
    const checkins = this.peekSortedCheckins();
    const symptoms = this.store.peekAll('symptom').toArray();
    const conditions = this.store.peekAll('condition').toArray();
    const treatments = this.store.peekAll('treatment').toArray();
    const trackables = [...conditions, ...symptoms, ...treatments, ...tags];

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

  onResizeEnd() {
    this.fetchDataChart();
  },

  actions: {
    navigate(days) {
      let centeredDate = get(this, 'centeredDate');

      centeredDate = centeredDate ? moment(centeredDate) : get(this, 'endAt').subtract(get(this, 'daysRadius'), 'days');

      set(this, 'centeredDate', centeredDate.add(days, 'days'));
    },

    setCurrentDate(date) {
      get(this, 'onDateClicked')(date);
    },

    openInfoWindow(date, xPosition) {
      set(this, 'xPosition', xPosition);
      set(this, 'openInfoWindow', true);
    },

    closeInfoWindow() {
      set(this, 'xPosition', null);
      set(this, 'openInfoWindow', false);
    },
  },
});
