import Ember from 'ember';
import DatesRetriever from 'flaredown/mixins/chart/dates-retriever';

const {
  get,
  set,
  on,
  computed,
  computed: { mapBy },
  Component,
  run: {
    scheduleOnce,
  },
  inject: {
    service,
  },
  observer,
  getProperties,
  incrementProperty,
} = Ember;

export default Component.extend(DatesRetriever, {
  ajax: service('ajax'),
  chartsVisibilityService: service('charts-visibility'),
  daysRadius: 7,
  page: 1,
  loadingPatterns: false,

  patternIdsChanged: on('init', observer('patterns.@each.id', 'startAt', 'endAt', function() {
    scheduleOnce('afterRender', this, '_loadChartData');
  })),

  _loadChartData() {
    const ids = get(this, 'patterns').mapBy('id');

    if(ids.length > 0) {
      get(this, 'ajax').request('/charts_pattern', {
        data: {
          pattern_ids: ids,
          start_at: get(this, 'startAt').format('YYYY-MM-DD'),
          end_at: get(this, 'endAt').format('YYYY-MM-DD')
        }
      }).then((data) => {
        set(this, 'chartData', data.charts_pattern);
      });
    }
  },

  actions: {
    newPattern() {
      this.sendAction('onCreate');
    },

    edit(pattern){
      this.sendAction('onEdit', pattern);
    },

    crossedTheLine(above) {
      set(this, 'loadingPatterns', true);

      this.sendAction('onRequest', this.incrementProperty('page', 1));
    },

    navigate(days) {
      let centeredDate = get(this, 'centeredDate');

      centeredDate = centeredDate ? moment(centeredDate) : get(this, 'endAt').subtract(get(this, 'daysRadius'), 'days');

      set(this, 'centeredDate', centeredDate.add(days, 'days'));
    },
  }
});
