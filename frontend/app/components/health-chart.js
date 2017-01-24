import Ember from 'ember';
import Resizable from './chart/resizable';
import FieldsByUnits from 'flaredown/mixins/fields-by-units';

const {
  Component,
  computed,
  get,
  getProperties,
  observer,
  set,
  computed: { alias },
  run: {
    debounce,
    scheduleOnce,
  },
} = Ember;

export default Component.extend(Resizable, FieldsByUnits, {
  classNames: ['health-chart'],

  checkins: [],
  trackables: [],
  flatHeight: 30,
  serieHeight: 75,
  seriePadding: 20,
  pixelsPerDate: 32,
  timelineHeight: 25,

  pressureUnits: alias('session.currentUser.profile.pressureUnits'),
  timelineLength: alias('timeline.length'),

  updateTrackables: observer('centeredDate', function() {
    debounce(this, this.fetchDataChart, 1000);
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

  series: computed('trackables', 'pressureUnits', function() {
    const { flatHeight, serieHeight, seriePadding } = getProperties(this, 'flatHeight', 'serieHeight', 'seriePadding');

    let chartOffset = 0 - serieHeight - seriePadding;
    let series = {
      conditions: [],
      symptoms:   [],
      treatments: [],
      weathersMesures: [],
    };

    get(this, 'trackables').forEach(item => {
      series[get(item, 'constructor.modelName').pluralize()].pushObject({ chartOffset: 0, model: item });
    });

    series.conditions.forEach(item => {
      item.chartOffset = chartOffset += serieHeight + seriePadding;
    });

    series.symptoms.forEach(item => {
      item.chartOffset = chartOffset += serieHeight + seriePadding;
    });

    series.treatments.forEach((item, index)  => {
      item.chartOffset = chartOffset += (index === 0 ? serieHeight : flatHeight) + seriePadding;
    });

    series.weathersMesures.pushObject({
      name: 'Avg daily humidity',
      unit: '%',
      field: 'humidity',
      chartOffset: chartOffset += flatHeight + seriePadding,
    });

    series.weathersMesures.pushObject({
      name: 'Avg daily atmospheric pressure',
      unit: get(this, 'pressureUnits'),
      field: this.pressureFieldByUnits(get(this, 'pressureUnits')),
      chartOffset: chartOffset += serieHeight + seriePadding,
    });

    return series;
  }),

  seriesLength: computed('series.weathersMesures.length', 'trackables.length', function() {
    return get(this, 'trackables.length') + get(this, 'series.weathersMesures.length');
  }),

  seriesWidth: computed('SVGWidth', function() {
    return get(this, 'SVGWidth') * 2;
  }),

  totalSeriesHeight: computed('series.weathersMesures.[]', function() {
    return(
      get(this, 'series.weathersMesures.lastObject.chartOffset') + get(this, 'serieHeight') + get(this, 'seriePadding')
    );
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

  didInsertElement() {
    this._super(...arguments);

    scheduleOnce('afterRender', this, () => {
      this.fetchDataChart().then(() => {
        set(this, 'chartLoaded', true);
      });
    });
  },

  fetchDataChart() {
    var startAt = get(this, 'startAtWithCache').format("YYYY-MM-DD");
    var endAt = get(this, 'endAtWithCache').format("YYYY-MM-DD");

    return this
      .store
      .queryRecord('chart', { id: 'health', start_at: startAt, end_at: endAt })
      .then(chart => {
        set(this, 'checkins', get(chart, 'checkins').sortBy('date:asc'));
        set(this, 'trackables', get(chart, 'trackables').sortBy('type'));
      });
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
