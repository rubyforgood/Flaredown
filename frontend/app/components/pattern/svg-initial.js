import Ember from 'ember';
import DatesRetriever from 'flaredown/mixins/chart/dates-retriever';
import moment from 'moment';

const {
  get,
  computed,
  Component,
} = Ember;

export default Component.extend(DatesRetriever, {
  yLine: [1, 1, 3, 3, 3, 1, 1, 0, 0, 0],
  yMarkerIndexes: { 'B12': [3, 4, 5, 6], 'Alcohol': [2, 3] },

  dates: computed('yLine', function() {
    const daysCount = (get(this, 'yLine.length'));
    let res = [];

    for(let i = 0; i < daysCount; i++) {
      res.push(moment().add(i+1, 'days').format('YYYY-MM-DD'));
    }

    return res.sort();
  }),

  lineData: computed('yLine', 'dates', function() {
    const dates = get(this, 'dates');
    const yLine = get(this, 'yLine');

    let datesHash =  dates.map((date) => {
      return { x: date, y: yLine[dates.indexOf(date)] };
    })

    get(datesHash, 'firstObject').average = true;
    get(datesHash, 'lastObject').average = true;

    return datesHash;
  }),

  markerFirstData(key) {
    const dates = get(this, 'dates');
    const yMarkerIndexes = get(this, 'yMarkerIndexes');

    let yValues = yMarkerIndexes[key];

    let filteredDates = dates.filter((date) => {
      if(yValues.includes(dates.indexOf(date))) {
        return date;
      }
    });

    return filteredDates.map((i) => {
      return {x: i}
    })
  },

  data: computed('dataLine', function() {
    return { pattern_name: 'initial', series: [
      { type: 'line', subtype: 'static', label: 'Fatigue', category: 'conditions', color_id: 1, data: get(this, 'lineData') },
      { type: 'marker', subtype: 'static', label: 'B12 supplement', category: 'treatments', color_id: 2, data: this.markerFirstData('B12') },
      { type: 'marker', subtype: 'static', label: 'Alcohol', category: 'treatments', color_id: 3, data: this.markerFirstData('Alcohol') }
    ]}
  }),

  startAt: computed('dates', function() {
    return moment(get(this, 'dates.firstObject'))
  }),

  endAt: computed('dates', function() {
    return moment(get(this, 'dates.lastObject')).subtract(1, 'days');
  }),
});
