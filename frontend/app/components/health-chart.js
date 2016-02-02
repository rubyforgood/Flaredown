/* global d3 */
import Ember from 'ember';
import Resizable from './chart/resizable';
import Draggable from './chart/draggable';

export default Ember.Component.extend(Resizable, Draggable, {
  classNames: ['health-chart'],

  store: Ember.inject.service(),

  checkins: [],
  trackings: [],

  serieHeight: 75,
  serieOffset: 10,
  seriesLength: Ember.computed.alias('trackables.length'),

  totalSeriesHeight: Ember.computed('seriesLength', 'serieHeight', 'serieOffset', function() {
    return this.get('seriesLength') * this.get('serieHeight') + this.get('seriesLength') * this.get('serieOffset');
  }),

  timelineHeight: 25,
  timelineLength: Ember.computed.alias('timeline.length'),

  SVGHeight: Ember.computed('timelineLength', 'seriesLength', function() {
    if(Ember.isPresent(this.get('seriesLength'))) {
      return this.get('totalSeriesHeight') + this.get('timelineHeight');
    } else {
      return this.get('timelineHeight');
    }
  }),

  SVGWidth: Ember.computed(function() {
    return this.$().width();
  }).volatile(),

  chartWidth: Ember.computed('SVGWidth', function() {
    return this.get('SVGWidth');
  }),

  viewport: Ember.computed(function() {
    return d3.select(this.$('.health-chart-viewport').get(0));
  }),

  timeline: Ember.computed('checkins', function() {
    var timeline = Ember.A();
    moment.range(this.get('startAt'), this.get('endAt') ).by('days', function(moment) {
      timeline.push(
        d3.time.format('%Y-%m-%d').parse(moment.format("YYYY-MM-DD"))
      );
    });
    return timeline;
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
    this.set('startAt', moment().subtract(30, 'days')),
    this.set('endAt', moment());

    this.fetchDataChart().then( () => {
      this.drawChart();
    });
  }),

  onDragged(direction, distance){
    this.fetchDataChart().then( () => {
      this.drawChart();
    });
  },

  onDragging(direction, distance){
    Ember.debug("CALCULATE NUMBER OF PAGE");
  },

  fetchDataChart() {
    var startAt = this.get('startAt').format("YYYY-MM-DD");
    var endAt = this.get('endAt').format("YYYY-MM-DD");

    Ember.debug("fetchDataChart from " + startAt + " to " + endAt);
    return this.get('store').queryRecord('chart', { id: 'health', start_at: startAt, end_at: endAt }).then( chart => {
      this.set('checkins', Ember.merge(chart.get('checkins').toArray(), this.get('checkins')) );
      this.set('trackings', Ember.merge(chart.get('trackings').toArray(), this.get('trackings')) );
    });
  },

  onResizeEnd() {
    this.drawChart();
  },

  clearChart() {
    this.$('.health-chart-viewport').children().remove();
  },

  drawChart() {
    Ember.RSVP.all(this.get('trackables')).then( (trackables) => {
      this.clearChart();
      trackables.forEach( (trackable, index) => {
        this.buildChart(trackable, index);
      });
      this.buildTimeline();
    });
  },

  fetchSerieFor(trackable) {
    var key = Ember.String.pluralize(trackable.get('constructor.modelName'));

    return this.get('timeline').map( (day) => {

      var checkin = this.get('checkins').findBy('formattedDate', moment(day).format("YYYY-MM-DD"));

      var coordinate = { x: day, y: null };

      if(Ember.isPresent(checkin)) {
        checkin.get(key).forEach( (item) => {
          if(parseInt(item.id)  === parseInt(trackable.get('id') ) ) {
            coordinate.y = item.value;
          }
        });
      }
      return coordinate;
    }).sortBy('x');
  },

  buildChart(trackable, index) {
    var data = this.fetchSerieFor(trackable);

    var chart = this.get('viewport').append("g").attr({
      class: 'chart',
      transform: "translate(0," + (this.get('serieHeight') * index + (this.get('serieOffset') * index)) + ")"
    });

    var x = d3.time.scale().range([0, this.get('chartWidth')]);
    var y = d3.scale.linear().range([this.get('serieHeight') , 0]);

    x.domain(d3.extent(data, function (d) {
       return d.x;
     }));

     y.domain([-1, d3.max(data, function (d) {
       return d.y;
     }) + 1]);

    var xAxis = d3.svg.axis().scale(x).orient("bottom").ticks(0);

    chart.insert('g')
        .attr("class", "axis x")
        .attr("stroke", 'black')
        .attr("transform", "translate(0," + this.get('serieHeight') + ")")
        .call(xAxis);


    var lineFunction = d3.svg.line()
                              .defined(function(d) {
                                if(Ember.$.isNumeric(d.y) ) {
                                  return d;
                                }
                              })
                             .x( function(d) { return x(d.x);})
                             .y(function(d) { return y(d.y); })
                             .interpolate("linear");

    chart.append("path")
         .attr("stroke", 'black')
         .attr("class", "line")
         .attr("d", lineFunction(data));

    chart.append("text")
        .attr({
          class: "title",
          stroke: 'black',
          transform: "translate(5,10)"
        })
        .text(function(d){
          return trackable.get('name');
        });


  },

  buildTimeline() {
    var data = this.get('timeline');

    var x = d3.time.scale().range([0, this.get('chartWidth')]);

    x.domain(d3.extent(data));

    var timeline = this.get('viewport').append("g").attr({
      class: 'timeline',
      transform: "translate(0," + this.get('totalSeriesHeight') + ")"
    });

    // Define the axes
    var xAxis = d3.svg.axis().scale(x)
        .orient("bottom").ticks(data.length).tickFormat(function(d, i){
          return moment(d).format("YYYY-MM-DD");
        });

    timeline.insert('g').attr({
      class: "axis timeline"
    }).call(xAxis)
    .selectAll('.tick')
    .on('click', this.handleDataClick.bind(this));
  },

  handleDataClick(date) {
    this.get('onDateClicked')(moment(date).format("YYYY-MM-DD"));
  }

});
