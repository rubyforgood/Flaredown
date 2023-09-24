import Ember from 'ember';
import DS from 'ember-data';
import moment from 'moment';

const {
  get,
  set,
  computed,
  computed: { alias },
  Component,
  inject: {
    service,
  },
  setProperties,
  A,
} = Ember;

export default Component.extend({
  ajax: service('ajax'),
  patternsLoading: service('patterns-loading'),
  logoVisiability: service(),

  page: 1,
  loadingPatterns: alias('patternsLoading.loadingPatterns'),
  patterns: [],
  colorIds: A(),
  backgroundMargin: { right: 10, left: 10 , top: 0 },

  startAt: moment().subtract(14, 'days'), // 7 daysRadius * 2
  endAt: moment(),

  chartData: computed('patterns.@each.id', 'startAt', 'endAt', 'daysRangeOffset', function() {
    const patterns = get(this, 'patterns');

    if(!patterns) {
      return;
    }

    const ids = patterns.mapBy('id');
    const chartDataPromise = get(this, 'chartDataPromise');
    const promise = get(this, 'ajax').request('/charts_pattern', {
      data: {
        pattern_ids: ids,
        start_at: get(this, 'startAt').format('YYYY-MM-DD'),
        end_at: get(this, 'endAt').format('YYYY-MM-DD'),
        offset: get(this, 'daysRangeOffset') || 1,
      }
    }).then((data) => data.charts_pattern);

    set(chartDataPromise, 'promise', promise);

    return chartDataPromise;
  }),

  init() {
    this._super(...arguments);

    set(this, 'chartDataPromise', DS.PromiseArray.create({}));
  },

  didInsertElement() {
    this._super(...arguments);

    // needs to be loaded
    get(this, 'chartData');

    set(this, 'logoVisiability.showHeaderPath', false);

    const resize = () => {
      const selection = this.$();
      if (!selection) {
        return;
      }
      const width = selection.width();

      set(this, 'indexPageWidth', width);
    };

    window.addEventListener("resize", resize);
    resize();
  },

  willDestroyElement(){
    set(this, '_isDestroyed', true);
  },

  authorName: computed('patterns.@each.authorName', function() {
    const names = get(this, 'patterns').mapBy('authorName').compact();
    const notEmpty = names.length > 0 ? names.filter((i) => i.length > 0).length > 0 : null;

    return notEmpty ? get(names, 'firstObject') : 'User';
  }),

  daysRangeOffset: computed('indexPageWidth', 'daysRange', function() {
    const backgroundMargin = get(this, 'backgroundMargin');
    const backgroundWidth = get(this, 'indexPageWidth') - backgroundMargin.left - backgroundMargin.right;
    const daysRange = get(this, 'daysRange');

    return Math.ceil((daysRange*backgroundMargin.left)/backgroundWidth);
  }),

  daysRange: computed('startAt', 'endAt', function() {
    return moment.duration(get(this, 'endAt') - get(this, 'startAt')).asDays();
  }),

  fixPatternColors(chartData) {
    chartData.map((chart) => {
      return this.addChartAttributes(chart.series);
    });
  },

  addChartAttributes(series) {
    let index = 0;

    series.map((i) => { // setColorId()
      i.index = index;
      index += 1;
    })
  },

  setColorId() {
    return get(this, 'colorIds').shiftObject();
  },

  actions: {
    newPattern() {
      this.sendAction('onCreate');
    },

    edit(pattern){
      this.sendAction('onEdit', pattern);
    },

    crossedTheLine() {
      set(this, 'loadingPatterns', true);

      this.sendAction('onRequest', this.incrementProperty('page', 1));
    },

    navigate(days) {
      const startAt = moment(get(this, 'startAt')).add(days, 'days');
      const endAt = moment(get(this, 'endAt')).add(days, 'days');

      setProperties(this, { startAt: startAt, endAt: endAt });
    },

    sharePattern() {
      this.transitionTo('patterns');
    },
  }
});
