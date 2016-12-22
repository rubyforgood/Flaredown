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
        .map(item => (
          {
            x: this.get('xScale')(item.x),
            y: this.get('yScale')(item.y),
            tip: {
              label: `${item.y}${this.get('unit')}`,
              x: this.get('xScale')(item.x) - 15,
              y: this.get('yScale')(item.y) - 10
            }
          }
        ))
    );
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

  yScale: Ember.computed('data', function() {
    let offset = (this.get('dataValuesYMax') - this.get('dataValuesYMin') + 1) / 4;

    return(
      d3
        .scale
        .linear()
        .range([this.get('height'), 0])
        .domain([this.get('dataValuesYMin') - offset, this.get('dataValuesYMax') + offset])
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
