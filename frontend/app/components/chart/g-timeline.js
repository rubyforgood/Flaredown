import Ember from 'ember';

export default Ember.Component.extend( {
  tagName: 'g',
  classNames: 'timeline',
  attributeBindings: ['transform'],

  startAt: Ember.computed(function() {
    return this.get('parentView.startAt');
  }).volatile(),

  endAt: Ember.computed(function() {
    return this.get('parentView.endAt');
  }).volatile(),

  timeline: Ember.computed(function() {
    return this.get('parentView.timeline');
  }).volatile(),

  timelineLength: Ember.computed(function() {
    return this.get('parentView.timelineLength');
  }).volatile(),

  width: Ember.computed(function() {
    return this.get('parentView.seriesWidth');
  }).volatile(),

  totalSeriesHeight: Ember.computed(function() {
    return this.get('parentView.totalSeriesHeight');
  }).volatile(),

  SVGWidth: Ember.computed(function() {
    return this.get('parentView.SVGWidth');
  }).volatile(),

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
      .on('mouseover', this.handleMouseHover.bind(this))
      .on('mouseleave', this.handleMouseLeave.bind(this));
  })),


  xAxis: Ember.computed('xScale', function() {
    return d3.svg.axis().scale(this.get('xScale')).orient("bottom").ticks(this.get('timelineLength')).tickFormat(function(d){
      return moment(d).format("MMM DD");
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

  handleMouseHover(date) {
    var formattedDate = moment(date).format("MMM DD");
    var position = null;

    d3.select(`g#${this.get('xAxisElementId')}`).selectAll('.tick').get(0).forEach( function(elem) {
      if(Ember.isEqual(elem.textContent, formattedDate)) {
        var clientRect = Ember.$(elem).get(0).getBoundingClientRect();
        position = clientRect.left + ( clientRect.width / 2);
      }
    });

    this.get('onMouseHover')(formattedDate, position );
  },

  handleMouseLeave(date) {
    this.get('onMouseLeave')(moment(date).format("YYYY-MM-DD") );
  }


});
