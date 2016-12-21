import Ember from 'ember';
import Colorable from 'flaredown/mixins/colorable';

export default Ember.Component.extend(Colorable, {
  tagName: 'g',
  colorId: '14',
  classNames: 'chart',
  attributeBindings: ['transform'],

  init() {
    this._super(...arguments);

    Ember.run.scheduleOnce('afterRender', () => {
      this.drawAxis();
    });
  },

  drawAxis: Ember.observer('xAxis', function() {
    if( Ember.isPresent(this.get('data')) ) {
      d3.select(`g#x-axis-${this.get('xAxisElementId')}`).call(this.get('xAxis'));
    }
  }),

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
              label: item.label,
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

  transform: Ember.computed('height', 'padding', 'index', function() {
    return `translate(0,${(this.get('height') + this.get('padding')) * this.get('index')})`;
  }),

  xAxisTransform: Ember.computed('height', 'startAt', 'data', function() {
    return `translate(${ - this.get('xScale')( this.get('startAt') )},${this.get('height')})`;
  }),

  nestedTransform: Ember.computed('height', 'startAt', 'data', function() {
    return `translate(${ - this.get('xScale')( this.get('startAt') )}, 5)`;
  }),

  xDomain: Ember.computed('data', function() {
    return d3.extent(this.get('data'), d => d.x);
  }),

  xScale: Ember.computed('data', function() {
    return(
      d3
        .time
        .scale()
        .range([0, this.get('width')])
        .domain(this.get('xDomain'))
    );
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
    let offset = (this.get('dataValuesYMax') - this.get('dataValuesYMin')) / 4;

    return(
      d3
        .scale
        .linear()
        .range([this.get('height'), 0])
        .domain([this.get('dataValuesYMin') - offset, this.get('dataValuesYMax') + offset])
    );
  }),

  xAxis: Ember.computed('xScale', function() {
    return(
      d3
        .svg
        .axis()
        .scale(this.get('xScale'))
        .orient('bottom')
        .ticks(0)
    );
  }),

  data: Ember.computed('checkins', function() {
    return (this.get('timeline') || []).map(day => {
      let checkin = this.get('checkins').findBy('formattedDate', moment(day).format('YYYY-MM-DD'));
      let coordinate = { x: day, y: null };

      if (Ember.isPresent(checkin)) {
        let item = checkin.get('weather');

        if (Ember.isPresent(item)) {
          coordinate.label = item.get(this.get('field'));
          coordinate.y = coordinate.label;
        }
      }

      return coordinate;
    });
  }),

  lineData: Ember.computed('data', function() {
    return this.get('data').reject(item => Ember.isEmpty(item.y));
  }),

  lineFunction: Ember.computed('lineData', function() {
    return(
      d3
        .svg
        .line()
        .x(this.getX.bind(this))
        .y(this.getY.bind(this))
        .interpolate('linear')
        (this.get('lineData'))
    );
  }),

  getX(d) {
    return this.get('xScale')(d.x);
  },

  getY(d) {
    return this.get('yScale')(d.y);
  },

  actions: {
    openPointTooltip(point) {
      this.set('openPointTooltip', true);
      this.set('currentPoint', point);
    },

    closePointTooltip() {
      this.set('openPointTooltip', false);
      this.set('currentPoint', null);
    },
  }
});
