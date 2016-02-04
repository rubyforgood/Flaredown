/* global d3 */
import Ember from 'ember';
import Resizable from './chart/resizable';
import Draggable from './chart/draggable';

export default Ember.Component.extend(Resizable, Draggable, {
  classNames: ['health-chart'],

  store: Ember.inject.service(),

  checkins: [],
  trackables: [],

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

  timeline: Ember.computed('startAt', 'endAt', function() {
    var timeline = Ember.A();
    moment.range(this.get('startAt'), this.get('endAt') ).by('days', function(moment) {
      timeline.push(
        d3.time.format('%Y-%m-%d').parse(moment.format("YYYY-MM-DD"))
      );
    });
    return timeline;
  }).volatile(),

  onInit: Ember.on('init',function(){
    this.set('startAt', moment().subtract(15, 'days')),
    this.set('endAt', moment());

    this.fetchDataChart().then( () => {
      this.drawChart();
    });
  }),

  onDragged(){
    this.fetchDataChart().then( () => {
      this.drawChart();
    });
  },

  onDragging(direction, distance){
    var checkinDate = null;

    if(Ember.isEqual('right', direction)) {

      var nextStartAt = moment(this.get('startAt')).subtract(1, 'days')
      var nextEndAt = moment(this.get('endAt')).subtract(1, 'days')

      if( nextStartAt > moment().subtract(90, 'days') ) {
        this.set('startAt',  nextStartAt);
        this.set('endAt',  nextEndAt);
        checkinDate = this.get('startAt').format("YYYY-MM-DD");
      }

    } else {
      var nextStartAt = moment(this.get('startAt')).add(1, 'days')
      var nextEndAt = moment(this.get('endAt')).add(1, 'days');

      if( nextEndAt < moment().add(3, 'days') ) {
        this.set('startAt', nextStartAt );
        this.set('endAt',  nextEndAt );
        checkinDate = nextEndAt.format("YYYY-MM-DD");
      }
    }

    var checkin = this.get('cachedCheckins').findBy('formattedDate', checkinDate);

    if(Ember.isPresent(checkin)) {
      this.get('checkins').pushObject( checkin );
    }

    this.drawChart();

  },

  fetchDataChart() {
    var startAt = this.get('startAt').format("YYYY-MM-DD");
    var endAt = this.get('endAt').format("YYYY-MM-DD");

    return this.get('store').queryRecord('chart', { id: 'health', start_at: startAt, end_at: endAt }).then( chart => {
      this.set('checkins', chart.get('checkins').sortBy('date:asc') );
      this.set('cachedCheckins', chart.get('cachedCheckins').sortBy('date:asc'));
      this.set('trackables', chart.get('trackables').sortBy('date:asc'));
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
    this.get('trackables').sortBy('type').forEach( (trackable, index) => {
      this.buildChart(trackable, index);
    });
    this.buildTimeline();
  },

  fetchSerieFor(trackable) {
    var type = trackable.get('constructor.modelName');
    var key = type.pluralize();

    return this.get('timeline').map( (day) => {

      var checkin = this.get('checkins').findBy('formattedDate', moment(day).format("YYYY-MM-DD"));

      var coordinate = { x: day, y: null };

      if(Ember.isPresent(checkin)) {
        checkin.get(key).forEach( item => {
          if(parseInt(item.get(`${type}.id`)) === parseInt(trackable.get('id'))) {
            coordinate.y = item.get('value');
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
     }) + 2]);

    var xAxis = d3.svg.axis().scale(x).orient("bottom").ticks(0);

    chart.insert('g')
        .attr("class", "axis x " + trackable.get('strokeClass'))
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
         .attr("class", "line " + trackable.get('strokeClass'))
         .attr("d", lineFunction(data));

    chart.append("text")
        .attr("class", "title " + trackable.get('strokeClass'))
        .attr("transform", "translate(5,12)")
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
