import Ember from 'ember';
import Colorable from 'flaredown/mixins/colorable';
import Graphable from 'flaredown/components/chart/graphable';

import { hbiLabel } from 'flaredown/helpers/hbi-label';

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

  rulerStep: computed('roundValuesYMin', 'roundValuesYMax', function() {
    let result = (get(this, 'roundValuesYMax') - get(this, 'roundValuesYMin')) / get(this, 'rangeDevider');

    return result || 2;
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
              label: hbiLabel([item.y]),
              x: x - 15,
              y: y - 10
            }
          };
        })
    );
  }),

  dataYValues: computed('data', function() {
    let result = [];

    for (let i = get(this, 'roundValuesYMin'); i < get(this, 'roundValuesYMax'); i += get(this, 'rulerStep')) {
      result.pushObject(Math.floor(i));
    }

    result.pushObject(get(this, 'roundValuesYMax'));

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
          get(this, 'roundValuesYMin') - get(this, 'rulerStep'),
          get(this, 'roundValuesYMax') + get(this, 'rulerStep')
        ])
    );
  }),

  data: computed('checkins', function() {
    return (get(this, 'timeline') || []).map(day => {
      let checkin = get(this, 'checkins').findBy('formattedDate', moment(day).format('YYYY-MM-DD'));
      let coordinate = { x: day, y: null };

      if (isPresent(checkin)) {
        let item = get(checkin, 'harveyBradshawIndex');

        if (isPresent(item)) {
          coordinate.y = get(item, get(this, 'field'));
        }
      }

      return coordinate;
    });
  }),
});
