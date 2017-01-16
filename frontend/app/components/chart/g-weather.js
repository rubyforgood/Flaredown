import Ember from 'ember';
import Colorable from 'flaredown/mixins/colorable';
import Graphable from 'flaredown/components/chart/graphable';

export default Ember.Component.extend(Colorable, Graphable, {
  colorId: '14',
  rangeDevider: 4,

  dataValuesYMin: Ember.computed.min('dataValuesY'),
  dataValuesYMax: Ember.computed.max('dataValuesY'),

  roundValuesYMin: Ember.computed('dataValuesYMin', function() {
    return Math.floor(this.get('dataValuesYMin'));
  }),

  roundValuesYMax: Ember.computed('dataValuesYMax', function() {
    return Math.ceil(this.get('dataValuesYMax'));
  }),

  isDecimalStep: Ember.computed('roundValuesYMin', 'roundValuesYMax', function() {
    return this.get('roundValuesYMax') - this.get('roundValuesYMin') < this.get('rangeDevider');
  }),

  chosenYMin: Ember.computed('isDecimalStep', function() {
    return this.get('isDecimalStep') ? this.get('dataValuesYMin') : this.get('roundValuesYMin');
  }),

  chosenYMax: Ember.computed('isDecimalStep', function() {
    return this.get('isDecimalStep') ? this.get('dataValuesYMax') : this.get('roundValuesYMax');
  }),

  rulerStep: Ember.computed('roundValuesYMin', 'roundValuesYMax', function() {
    return (this.get('chosenYMax') - this.get('chosenYMin')) / this.get('rangeDevider');
  }),

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
    let result = [];

    const finalizeNumber =this.get('isDecimalStep') ?
      number => Math.round(number * 100) / 100
    :
      number => Math.floor(number);

    for (let i = this.get('chosenYMin'); i < this.get('chosenYMax'); i += this.get('rulerStep')) {
      result.pushObject(finalizeNumber(i));
    }

    result.pushObject(this.get('chosenYMax'));

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

  yScale: Ember.computed('data', function() {
    return(
      d3
        .scale
        .linear()
        .range([this.get('height'), 0])
        .domain([
          this.get('chosenYMin') - this.get('rulerStep'),
          this.get('chosenYMax') + this.get('rulerStep')
        ])
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
