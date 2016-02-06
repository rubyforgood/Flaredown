/* global d3, moment */
import Ember from 'ember';
import HealthChartComponent from '../health-chart';

export default Ember.Component.extend( {
  tagName: 'g',
  classNames: 'timeline',
  attributeBindings: ['transform'],

  startAt: Ember.computed.alias('parentView.startAt'),

  timeline: Ember.computed.alias('parentView.timeline'),
  timelineLength: Ember.computed.alias('parentView.timelineLength'),

  width: Ember.computed.alias('parentView.seriesWidth'),
  totalSeriesHeight: Ember.computed.alias('parentView.totalSeriesHeight'),

  shouldAlwaysBeWithinAHelthChartComponent: Ember.on('didInsertElement', function() {
    Ember.run.scheduleOnce('afterRender', () => {
      var parentView = this.get('parentView');
      var elementId = this.get('elementId');
      Ember.assert("HealthChartComponent (element ID: " + elementId + ") must have a parent view in order to yield.", parentView);
      Ember.assert(
        "HealthChartComponent (element ID: " + elementId + ") should be inside a HealthChartComponent.",
        HealthChartComponent.detectInstance(parentView)
      );
    });
  }),

  xAxisElementId: Ember.computed(function() {
    return "x-axis-timeline";
  }),

  transform: Ember.computed('xScale', 'startAt', 'totalSeriesHeight', function() {
    return `translate(${ - this.get('xScale')( this.get('startAt') )},${this.get('totalSeriesHeight')})`;
  }),

  drawAxis: Ember.on('didInsertElement', Ember.observer('xAxis', function() {
    d3.select(`g#${this.get('xAxisElementId')}`)
      .call(this.get('xAxis'))
      .selectAll('.tick')
      .on('click', this.handleDataClick.bind(this))
      .on('mouseover', this.handleDataHover.bind(this));
  })),


  xAxis: Ember.computed('xScale', function() {
    return d3.svg.axis().scale(this.get('xScale')).orient("bottom").ticks(this.get('timelineLength')).tickFormat(function(d, i){
      return moment(d).format("YYYY-MM-DD");
    });
  }),

  xScale: Ember.computed('xDomain', function() {
    return d3.time.scale()
                  .range([0, this.get('width')])
                  .domain(this.get('xDomain'));
  }),

  xDomain: Ember.computed('timeline', function() {
    return d3.extent(this.get('timeline'));
  }),

  handleDataClick(date) {
    this.get('onDateClicked')(moment(date).format("YYYY-MM-DD"));
  },

  handleDataHover(date) {
    this.get('onDateHovered')(moment(date).format("YYYY-MM-DD"));
  }

});
