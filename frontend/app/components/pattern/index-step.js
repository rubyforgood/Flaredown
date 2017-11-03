import Ember from 'ember';
import DS from 'ember-data';

const {
  get,
  set,
  on,
  computed,
  Component,
  run: {
    scheduleOnce,
  },
  inject: {
    service,
  },
  observer,
  setProperties,
  A,
} = Ember;

export default Component.extend({
  ajax: service('ajax'),
  chartsVisibilityService: service('charts-visibility'),
  page: 1,
  loadingPatterns: false,
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

    return DS.PromiseArray.create({
      promise: get(this, 'ajax').request('/charts_pattern', {
        data: {
          pattern_ids: ids,
          start_at: get(this, 'startAt').format('YYYY-MM-DD'),
          end_at: get(this, 'endAt').format('YYYY-MM-DD'),
          offset: get(this, 'daysRangeOffset') || 1,
        }
      }).then((data) => data.charts_pattern)
    })
  }),

  didInsertElement() {
    this._super(...arguments);

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
  }
});
