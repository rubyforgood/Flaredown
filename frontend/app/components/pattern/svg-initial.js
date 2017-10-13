import Ember from 'ember';

const {
  get,
  computed,
  Component,
} = Ember;

export default Component.extend({
  yLine: [2, 2, 3, 3, 2, 2, 1, 1],
  yMarkerIndexes: { 'B12': [3, 4, 5, 6, 7], 'Alcohol': [2, 3] },

  dates: computed('yLine', function() {
    const yLine = get(this, 'yLine');
    let res = [];

    for(let i = 0; i < yLine.length; i++) {
      res.push(moment().add(i+1, 'days').format('YYYY-MM-DD'));
    }

    return res.sort();
  }),

  lineData: computed('yLine', 'dates', function() {
    const dates = get(this, 'dates');
    const yLine = get(this, 'yLine');

    return dates.map((date) => {
      return { x: date, y: yLine[dates.indexOf(date)] };
    });
  }),

  markerFirstData(key) {
    const dates = get(this, 'dates');
    const yMarkerIndexes = get(this, 'yMarkerIndexes');

    let yValues = yMarkerIndexes[key];
    let res =  dates.map((date) => {
      let yValue = yValues.includes(dates.indexOf(date)) ? 1 : null;
      return { x: date, y: yValue }
    })

    return res;
  },

  data: computed('dataLine', function() {
    return { pattern_name: 'initial', series: [
      { type: 'line', subtype: 'static', label: 'Fatigue', category: 'conditions', color_id: 1, data: get(this, 'lineData')
      },
      { type: 'marker', subtype: 'static', label: 'B12 supplement', category: 'treatments', color_id: 2, data: this.markerFirstData('B12')
      },
      {
        type: 'marker', subtype: 'static', label: 'Alcohol', category: 'treatments', color_id: 3, data: this.markerFirstData('Alcohol')
      }
    ]}
  }),
});
