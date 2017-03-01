import Ember from 'ember';
import Colorable from 'flaredown/mixins/colorable';
import Graphable from 'flaredown/components/chart/graphable';

import { hbiLabel } from 'flaredown/helpers/hbi-label';

const {
  $,
  get,
  computed,
  Component,
  isPresent,
  getProperties,
} = Ember;

export default Component.extend(Colorable, Graphable, {
  colorId: '35',
  rangeDevider: 4,

  yRulersMax: computed.max('yRulers'),
  yRulersMin: computed.min('yRulers'),
  dataValuesYMax: computed.max('dataValuesY'),
  dataValuesYMin: computed.min('dataValuesY'),

  rulerStep: computed('dataValuesYMin', 'dataValuesYMax', function() {
    const {
      rangeDevider,
      dataValuesYMax,
      dataValuesYMin,
    } = getProperties(this, 'dataValuesYMax', 'dataValuesYMin', 'rangeDevider');

    const result = Math.ceil((dataValuesYMax - dataValuesYMin) / rangeDevider);

    return result || 1;
  }),

  domainPadding: computed('yRulersMax', 'yRulersMin', function() {
    const { rangeDevider, yRulersMax, yRulersMin } = getProperties(this, 'rangeDevider', 'yRulersMax', 'yRulersMin');

    return (yRulersMax - yRulersMin) / rangeDevider;
  }),

  domain: computed('yRulersMax', 'yRulersMin', 'domainPadding', function() {
    const {
      yRulersMax,
      yRulersMin,
      domainPadding,
    } = getProperties(this, 'yRulersMax', 'yRulersMin', 'domainPadding');

    return [
      yRulersMin - domainPadding,
      yRulersMax + domainPadding,
    ];
  }),

  points: computed('data', function() {
    const { data, xScale, yScale } = getProperties(this, 'data', 'xScale', 'yScale');

    return(
      data
        .filter(item => $.isNumeric(item.y))
        .map(item => {
          const x = xScale(item.x);
          const y = yScale(item.y) - 4; // minus radius

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

  yRulers: computed('data', function() {
    const {
      rulerStep,
      dataValuesYMax,
      dataValuesYMin,
    } = getProperties(this, 'dataValuesYMax', 'dataValuesYMin', 'rulerStep');

    let result = [];
    const max = dataValuesYMax + rulerStep;

    for (let i = dataValuesYMin; i < max; i += rulerStep) {
      result.pushObject(i);
    }

    result = result.uniq();

    if (result.length < 4) {
      result.pushObjects([dataValuesYMax + rulerStep, dataValuesYMin - rulerStep]);

      let offset = dataValuesYMin - rulerStep;

      offset = offset >= 0 ? 0 : offset;

      return result.uniq().map(v => v - offset);
    } else {
      return result;
    }
  }),

  dataValuesY: computed('data', function() {
    const values = get(this, 'data')
      .filter(item => item.y || item.y === 0)
      .map(item => item.y)
      .compact();

    return values.length ? values : [0, 100];
  }),

  yScale: computed('data', function() {
    const { height, domain } = getProperties(this, 'height', 'domain');

    return(
      d3
        .scale
        .linear()
        .range([height, 0])
        .domain(domain)
    );
  }),

  data: computed('checkins', function() {
    const {
      field,
      checkins,
      timeline,
    } = getProperties(this, 'field', 'timeline', 'checkins');

    return (timeline || []).map(day => {
      let checkin = checkins.findBy('formattedDate', moment(day).format('YYYY-MM-DD'));
      let coordinate = { x: day, y: null };

      if (isPresent(checkin)) {
        let item = get(checkin, 'harveyBradshawIndex');

        if (isPresent(item)) {
          coordinate.y = get(item, field);
        }
      }

      return coordinate;
    });
  }),
});
