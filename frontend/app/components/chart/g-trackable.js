import Ember from 'ember';
import HealthChartComponent from '../health-chart';

export default Ember.Component.extend( {
  tagName: 'g',
  classNames: 'chart',
  attributeBindings: ['transform'],

  padding: Ember.computed.alias('parentView.seriePadding'),
  height: Ember.computed.alias('parentView.serieHeight'),
  width: Ember.computed.alias('parentView.seriesWidth'),

  checkins: Ember.computed.alias('parentView.checkins'),
  timeline: Ember.computed.alias('parentView.timeline'),
  startAt: Ember.computed.alias('parentView.startAt'),
  endAt: Ember.computed.alias('parentView.endAt'),


  type: 'line',
  isLineSerie: Ember.computed.equal('type', 'line'),
  isSymbolSerie: Ember.computed.equal('type', 'symbol'),

  onDidInsertElement: Ember.on('didInsertElement', function() {
    Ember.run.scheduleOnce('afterRender', () => {
      this.shouldAlwaysBeWithinAHelthChartComponent();
      this.drawAxis();
    });
  }),

  shouldAlwaysBeWithinAHelthChartComponent() {
    var parentView = this.get('parentView');
    var elementId = this.get('elementId');
    Ember.assert("HealthChartComponent (element ID: " + elementId + ") must have a parent view in order to yield.", parentView);
    Ember.assert(
      "HealthChartComponent (element ID: " + elementId + ") should be inside a HealthChartComponent.",
      HealthChartComponent.detectInstance(parentView)
    );
  },

  drawAxis: Ember.observer('xAxis', function() {
    if( Ember.isPresent(this.get('data')) ) {
      d3.select(`g#x-axis-${this.get('xAxisElementId')}`).call(this.get('xAxis'));
    }
  }),

  markers: Ember.computed('data', function() {
    return this.get('data').filter( (item) => {
      return item.y === true;
    }).map( (item) => {
      return {
        x: this.get('xScale')(item.x) - 20 ,
        y: this.get('yScale')(2.5),
        tip: {
          label: item.label,
          x: this.get('xScale')(item.x) - 15,
          y: this.get('yScale')(item.y) - 15
        }
      };
    });
  }),

  points: Ember.computed('data', function() {
    return this.get('data').filter( (item) => {
      return Ember.$.isNumeric(item.y);
    }).map( (item) => {
      return {
        x: this.get('xScale')(item.x),
        y: this.get('yScale')(item.y),
        tip: {
          label: item.label,
          x: this.get('xScale')(item.x) - 15,
          y: this.get('yScale')(item.y) - 10
        }
      };
    });
  }),

  xAxisElementId: Ember.computed('model', function() {
    return `${this.get('model.constructor.modelName')}-${this.get('model.id')}`;
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
    return d3.extent(this.get('data'), function (d) {
      return d.x;
    });
  }),

  xScale: Ember.computed('data', function() {
    return d3.time.scale()
                  .range([0, this.get('width')])
                  .domain(this.get('xDomain'));
  }),

  yScale: Ember.computed('data', function() {
    return d3.scale.linear().range([this.get('height') , 0]).domain([-1, 5]);
  }),

  xAxis: Ember.computed('xScale', function() {
    return d3.svg.axis().scale(this.get('xScale')).orient("bottom").ticks(0);
  }),

  data: Ember.computed('checkins', function() {
    var trackable = this.get('model');
    var type = trackable.get('constructor.modelName');
    var key = type.pluralize();
    var timeline = this.get('timeline') || [];
    return timeline.map( (day) => {
      var checkin = this.get('checkins').findBy('formattedDate', moment(day).format("YYYY-MM-DD"));

      var coordinate = { x: day, y: null };

      if(Ember.isPresent(checkin)) {
        var item = checkin.get(key).findBy(`${type}.id`, trackable.get('id'));

        if(Ember.isPresent(item) && (Ember.isPresent(item.get('value')) || item.get('isTaken')) ) {
          coordinate.label = item.get('value');

          if(Ember.$.isNumeric(item.get('value')) ) {
            coordinate.y = item.get('value');
          } else if (Ember.isEqual(item.get('isTaken'), true)) {
            coordinate.y = true;
          }
        }
      }

      return coordinate;
    }).sortBy('x');
  }),

  lineData: Ember.computed('data', function() {
    return this.get('data').reject( (item) => {
      return Ember.isEmpty(item.y);
    });
  }),

  lineFunction: Ember.computed('lineData', function() {
     return d3.svg.line().x(this.getX.bind(this))
                         .y(this.getY.bind(this))
                         .interpolate("linear")(this.get('lineData'));
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

    openMarkerTooltip(marker) {
      this.set('openMarkerTooltip', true);
      this.set('currentMarker', marker);
    },

    closeMarkerTooltip() {
      this.set('openMarkerTooltip', false);
      this.set('currentMarker', null);
    }
  }
});
