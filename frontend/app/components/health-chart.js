/* global d3 */
import Ember from 'ember';
import Resizable from './chart/resizable';
import Draggable from './chart/draggable';

export default Ember.Component.extend(Resizable, Draggable, {
  classNames: ['health-chart'],

  store: Ember.inject.service(),

  serieHeight: 100,
  serieOffset: 20,
  seriesLength: Ember.computed.alias('model.series.length'),

  timelineHeight: 100,
  timelineLength: Ember.computed.alias('model.timeline.length'),

  startAt: '2016-01-01',
  endAt: '2016-01-31',

  SVGHeight: Ember.computed('seriesLength', function() {
    if( Ember.isPresent(this.get('seriesLength')) ) {
      return this.get('seriesLength') * this.get('serieHeight') + this.get('seriesLength') * this.get('serieOffset') + this.get('timelineHeight');
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

  onInit: Ember.on('init',function(){
    this.setupModel().then( () => {
      this.drawChart();
    });
  }),

  onDragging(direction, distance){

  },

  setupModel() {
    return this.get('store').queryRecord('chart', { id: 'health', start_at: this.get('startAt'), end_at: this.get('endAt') }).then( chart => {
      this.set('model', chart);
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
    this.get('model.series').forEach( (serie, index) => {
      this.buildChart(serie, index);
    });
    this.buildTimeline();
  },

  buildChart(serie, index) {
    var chart = this.get('viewport').append("g").attr({
      class: 'chart',
      transform: "translate(0," + (this.get('serieHeight') * index + (this.get('serieOffset') * index)) + ")"
    });

    var x = d3.time.scale().range([0, this.get('SVGWidth')]);
    var y = d3.scale.linear().range([this.get('serieHeight') , 0]);

    x.domain(d3.extent(serie.data, (d) => { return d.x; }));

    y.domain([0, d3.max(serie.data, (d) => { return d.y; })]);

    var lineFunction = d3.svg.line()
                             .x(function(d) { return x(d.x); })
                             .y(function(d) { return y(d.y); })
                             .interpolate("linear");

    chart.append("path")
         .attr("stroke", serie.color)
         .attr("class", "line")
         .attr("d", lineFunction(serie.data));


    var xAxis = d3.svg.axis().scale(x)
        .orient("bottom").ticks(0);

    chart.insert('g')
        .attr("class", "axis x")
        .attr("stroke", serie.color)
        .attr("transform", "translate(0," + this.get('serieHeight') + ")")
        .call(xAxis);
  },

  buildTimeline() {
    var data = this.get('model.timeline');

    var x = d3.time.scale().range([0, this.get('SVGWidth')]);

    x.domain(d3.extent(data, (d) => { return d.x; }));

    var chart = this.get('viewport').append("g").attr({
      class: 'timeline',
      transform: "translate(0," + (this.get('timelineHeight') * this.get('seriesLength')) + ")"
    });

    // Define the axes
    var xAxis = d3.svg.axis().scale(x)
        .orient("bottom").ticks(data.length);

    chart.insert('g').attr({
      class: "axis timeline",
      transform: "translate(0," + this.get('timelineHeight') + ")"
    }).call(xAxis);

  }

});
