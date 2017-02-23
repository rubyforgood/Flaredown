import Ember from 'ember';
import Colorable from 'flaredown/mixins/colorable';
import Graphable from 'flaredown/components/chart/graphable';

const { $, Component, computed, get, isPresent } = Ember;

export default Component.extend(Colorable, Graphable, {
  colorId: '35',
  rangeDevider: 4,

  dataValuesYMin: computed.min('dataValuesY'),
  dataValuesYMax: computed.max('dataValuesY'),

  roundValuesYMin: computed('dataValuesYMin', function() {
    return Math.floor(get(this, 'dataValuesYMin'));
  }),

  roundValuesYMax: computed('dataValuesYMax', function() {
    return Math.ceil(get(this, 'dataValuesYMax'));
  }),

  isDecimalStep: computed('roundValuesYMin', 'roundValuesYMax', function() {
    return get(this, 'roundValuesYMax') - get(this, 'roundValuesYMin') < get(this, 'rangeDevider');
  }),

  chosenYMin: computed('isDecimalStep', function() {
    return get(this, get(this, 'isDecimalStep') ? 'dataValuesYMin' : 'roundValuesYMin');
  }),

  chosenYMax: computed('isDecimalStep', function() {
    return get(this, get(this, 'isDecimalStep') ? 'dataValuesYMax' : 'roundValuesYMax');
  }),

  rulerStep: computed('roundValuesYMin', 'roundValuesYMax', function() {
    return (get(this, 'chosenYMax') - get(this, 'chosenYMin')) / get(this, 'rangeDevider');
  }),

  points: computed('data', function() {
    return(
      get(this, 'data')
        .filter(item => $.isNumeric(item.y))
        .map(item => {
          const x = get(this, 'xScale')(item.x);
          const y = get(this, 'yScale')(item.y) - 4; // minus radius

          return {
            x,
            y,
            tip: {
              label: `${item.y}${get(this, 'unit')}`,
              x: x - 15,
              y: y - 10
            }
          };
        })
    );
  }),

  yRulers: computed('data', function() {
    let result = [];

    const finalizeNumber = get(this, 'isDecimalStep') ?
      number => Math.round(number * 100) / 100
    :
      number => Math.floor(number);

    for (let i = get(this, 'chosenYMin'); i < get(this, 'chosenYMax'); i += get(this, 'rulerStep')) {
      result.pushObject(finalizeNumber(i));
    }

    result.pushObject(get(this, 'chosenYMax'));

    return result.uniq();
  }),

  dataValuesY: computed('data', function() {
    const values = get(this, 'data')
      .filter(item => item.y || item.y === 0)
      .map(item => item.y)
      .compact();

    return values.length ? values : [0, 100];
  }),

  yScale: computed('data', function() {
    return(
      d3
        .scale
        .linear()
        .range([get(this, 'height'), 0])
        .domain([
          get(this, 'chosenYMin') - get(this, 'rulerStep'),
          get(this, 'chosenYMax') + get(this, 'rulerStep')
        ])
    );
  }),

  data: computed('checkins', function() {
    return (get(this, 'timeline') || []).map(day => {
      let checkin = get(this, 'checkins').findBy('formattedDate', moment(day).format('YYYY-MM-DD'));
      let coordinate = { x: day, y: null };

      if (isPresent(checkin)) {
        let item = get(checkin, 'weather');

        if (isPresent(item)) {
          coordinate.y = get(item, get(this, 'field'));
        }
      }

      return coordinate;
    });
  }),
});
