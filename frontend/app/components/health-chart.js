/* global d3 */
import Ember from 'ember';
import Resizable from './chart/resizable';
import Draggable from './chart/draggable';

export default Ember.Component.extend(Resizable, Draggable, {
  classNames: ['health-chart'],

  store: Ember.inject.service(),

  serieHeight: 75,
  serieOffset: 10,
  seriesLength: Ember.computed.alias('trackables.length'),

  totalSeriesHeight: Ember.computed('seriesLength', 'serieHeight', 'serieOffset', function() {
    return this.get('seriesLength') * this.get('serieHeight') + this.get('seriesLength') * this.get('serieOffset');
  }),

  timelineHeight: 25,
  timelineLength: Ember.computed.alias('timeline.length'),

  startAt: '2016-01-01',
  endAt: '2016-01-31',

  SVGHeight: Ember.computed('timelineLength', 'seriesLength', function() {
    if(Ember.isPresent(this.get('seriesLength'))) {
      return this.get('totalSeriesHeight') + this.get('timelineHeight');
    } else {
      return this.get('timelineHeight');
    }
  }),

  SVGWidth: Ember.computed(function() {
    return this.$().width();
  }),

  viewport: Ember.computed(function() {
    return d3.select(this.$('.health-chart-viewport').get(0));
  }),

  timeline: Ember.computed('checkins', function() {
    return this.get('checkins').sortBy('date').map( (item) => {
      return item.get('date');
    });
  }),

  trackables: Ember.computed('trackings', function() {
    if(Ember.isPresent(this.get('trackings'))) {
      return this.get('trackings').map( (item) => {
        return item.get('trackable');
      });
    } else {
      return Ember.A();
    }
  }),

  onInit: Ember.on('init',function(){
    this.setupModel().then( () => {
      this.drawChart();
    });
  }),

  onDragging(direction, distance){
    Ember.debug("direction: " + direction + " distance: " + distance);
  },

  setupModel() {
    return this.get('store').queryRecord('chart', { id: 'health', start_at: this.get('startAt'), end_at: this.get('endAt') }).then( chart => {
      this.set('checkins', chart.get('checkins').toArray() );
      this.set('trackings', chart.get('trackings').toArray() );
    });
  },

  onResizeEnd() {
    this.drawChart();
  },

  clearChart() {
    this.$('.health-chart-viewport').children().remove();
  },

  drawChart() {
    this.clearChart();
    Ember.RSVP.all(this.get('trackables')).then( (trackables) => {
      trackables.forEach( (trackable, index) => {
        this.buildChart(trackable, index);
      });
    });
    this.buildTimeline();
  },

  fetchSerieFor(trackable) {
    var key = Ember.String.pluralize(trackable.get('constructor.modelName'));

    return this.get('checkins').map( (checkin) => {
      var coordinate = { x: checkin.get('date'), y: 0 };

      checkin.get(key).forEach( (item) => {
        if(parseInt(item.id)  === parseInt(trackable.get('id') ) ) {
          var value = parseInt(item.value);
          if( Ember.$.isNumeric(value) ) {
            coordinate.y = value;
          } else {
            coordinate.y = true;
          }
        }
      });
      return coordinate;
    }).sortBy('x');

  },

  buildChart(trackable, index) {

    Ember.debug("buildChart for index: " + index + " " + trackable.get('name') + " -> " + trackable.get('id'));

    var data = this.fetchSerieFor(trackable);

    var chart = this.get('viewport').append("g").attr({
      class: 'chart',
      transform: "translate(0," + (this.get('serieHeight') * index + (this.get('serieOffset') * index)) + ")"
    });

    var x = d3.time.scale().range([0, this.get('SVGWidth')]);
    var y = d3.scale.linear().range([this.get('serieHeight') , 0]);

    x.domain(d3.extent(data, function (d) {
       return d.x;
     }));

     y.domain([0, d3.max(data, function (d) {
       return d.y;
     })]);

    var xAxis = d3.svg.axis().scale(x).orient("bottom").ticks(0);

    chart.insert('g')
        .attr("class", "axis x")
        .attr("stroke", 'black')
        .attr("transform", "translate(0," + this.get('serieHeight') + ")")
        .call(xAxis);

    var lineFunction = d3.svg.line()
                             .x( function(d) { return x(d.x);})
                             .y(function(d) { return y(d.y); })
                             .interpolate("linear");

    chart.append("path")
         .attr("stroke", 'black')
         .attr("class", "line")
         .attr("d", lineFunction(data));


  },

  buildTimeline() {
    var data = this.get('timeline');

    var x = d3.time.scale().range([0, this.get('SVGWidth')]);

    x.domain(d3.extent(data));

    var timeline = this.get('viewport').append("g").attr({
      class: 'timeline',
      transform: "translate(0," + this.get('totalSeriesHeight') + ")"
    });

    // Define the axes
    var xAxis = d3.svg.axis().scale(x)
        .orient("bottom").ticks(data.length);

    timeline.insert('g').attr({
      class: "axis timeline"
    }).call(xAxis);

  }

});
