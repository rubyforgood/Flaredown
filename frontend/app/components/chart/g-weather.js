import Ember from 'ember';
import Colorable from 'flaredown/mixins/colorable';
import Graphable from 'flaredown/components/chart/graphable';

export default Ember.Component.extend(Colorable, Graphable, {
  colorId: '14',

  points: Ember.computed('data', function() {
    return(
      this
        .get('data')
        .filter(item => Ember.$.isNumeric(item.y))
        .map(item => {
          const x = this.get('xScale')(item.x);
          const y = this.get('yScale')(item.y) - 4; // minus radius

          return {
            x,
            y,
            tip: {
              label: `${item.y}${this.get('unit')}`,
              x: x - 15,
              y: y - 10
            }
          };
        })
    );
  }),

  dataYValues: Ember.computed('data', function() {
    const min = this.get('roundValuesYMin');
    const max = this.get('roundValuesYMax');
    const step = (max - min) / 4;

    let result = [];

    for (let i = min; i < max; i += step) {
      result.pushObject(Math.floor(i));
    }

    result.pushObject(max);

    return result.uniq();
  }),

  xAxisElementId: Ember.computed('name', function() {
    return this.get('name').replace(/\W/g, '-');
  }),

  dataValuesY: Ember.computed('data', function() {
    return (
      this
        .get('data')
        .map(item => item.y)
        .compact()
    );
  }),

  dataValuesYMax: Ember.computed.max('dataValuesY'),
  dataValuesYMin: Ember.computed.min('dataValuesY'),

  roundValuesYMax: Ember.computed('dataValuesYMax', function() {
    return Math.ceil(this.get('dataValuesYMax'));
  }),

  roundValuesYMin: Ember.computed('dataValuesYMin', function() {
    return Math.floor(this.get('dataValuesYMin'));
  }),

  yScale: Ember.computed('data', function() {
    let offset = (this.get('roundValuesYMax') - this.get('roundValuesYMin') + 1) / 4;

    return(
      d3
        .scale
        .linear()
        .range([this.get('height'), 0])
        .domain([this.get('roundValuesYMin') - offset, this.get('roundValuesYMax') + offset])
    );
  }),

  data: Ember.computed('checkins', function() {
    return (this.get('timeline') || []).map(day => {
      let checkin = this.get('checkins').findBy('formattedDate', moment(day).format('YYYY-MM-DD'));
      let coordinate = { x: day, y: null };

      if (Ember.isPresent(checkin)) {
        let item = checkin.get('weather');

        if (Ember.isPresent(item)) {
          coordinate.y = item.get(this.get('field'));
        }
      }

      return coordinate;
    });
  }),
});
