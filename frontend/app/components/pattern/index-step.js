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
  setProperties,
} = Ember;

export default Component.extend(DatesRetriever, {
  ajax: service('ajax'),
  chartsVisibilityService: service('charts-visibility'),

  // pixelsPerDate: 32,

  startAt: computed(function() {
    return moment('2017-09-20');
  }),

  endAt: computed(function() {
    return moment('2017-10-10');
  }),

  patternIdsChanged: on('init', observer('patterns.@each.id', 'startAt', 'endAt', function() {
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
  })),

  fetchCheckins() {
    set(this, 'checkins', get(this, 'fetchedCheckins'));
  },

  fetchedCheckins: computed(function() {
    return this
      .store
      .findAll('checkin')
      .toArray()
      .sort(
        (a, b) => moment(get(a, 'date')).diff(get(b, 'date'), 'days')
      );
  }),

  timeline: computed('checkins', 'startAt', 'endAt', function() {
    debugger;
    let timeline = Ember.A();

    moment.range(get(this, 'startAtWithCache'), get(this, 'endAtWithCache')).by('days', function(day) {
      timeline.pushObject(
        d3.time.format('%Y-%m-%d').parse(day.format("YYYY-MM-DD"))
      );
    });

    return timeline;
  }),


  actions: {
    newPattern() {
      this.sendAction('onCreate');
    },

    edit(pattern){
      this.sendAction('onEdit', pattern);
    },

    navigate(days) {
      let centeredDate = get(this, 'centeredDate');

      centeredDate = centeredDate ? moment(centeredDate) : get(this, 'endAt').subtract(get(this, 'daysRadius'), 'days');

      set(this, 'centeredDate', centeredDate.add(days, 'days'));
    },
  }
});
