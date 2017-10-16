import Ember from 'ember';

/* global d3 */

const {
  get,
  set,
  computed,
  computed: {
    filter,
  },
  observer,
  Component
} = Ember;

export default Component.extend({
  classNames: ['flaredown-white-box', 'max-width', 'flaredown-svg-group'],

  svg: null,
  data: null,
  svgHeight: 0,

  svgChartWidth: 500,
  svgLineAreaHeight: 150,
  svgLineOffset: 20,
  svgLineHeight: 3,
  startAt: null,
  endAt: null,
  margin: { top: 25, right: 5, bottom: 5, left: 10 },
  marginOffset: 20,

  init(){
    this._super(...arguments);

    const xScale = d3.time.scale().range([0, get(this, 'svgChartWidth')]);
    const yScaleStatic = d3.scale.linear().range([get(this, 'svgLineAreaHeight'), 0]);
    const yScaleDynamic = d3.scale.linear().range([get(this, 'svgLineAreaHeight'), 0]);

    set(this, 'xScale', xScale);
    set(this, 'yScaleStatic', yScaleStatic);
    set(this, 'yScaleDynamic', yScaleDynamic);
  },

  didInsertElement() {
    this._super(...arguments);

    const svg = d3.select(this.element).select('svg').append('g').attr('class', 'offset');

    const margin = get(this, 'margin');

    svg.attr("transform", "translate(" + margin.left + "," + margin.top + ")"); // svg references to g

    const resize = () => {
      const width = this.$().width();

      set(this, 'svgWidth', width);
      set(this, 'svgChartWidth', width - margin.left - margin.right);
    };
    set(this, 'svg', svg);

    window.addEventListener("resize", resize);

    resize();
  },

  xScaleObserver: observer('svgChartWidth', function(){
    get(this, 'xScale').range([0, get(this, 'svgChartWidth') ]);
  }),

  svgGroupObserver: observer('svg', function() {
    const svg = get(this, 'svg');

    if(!svg) {
      return;
    }

    if(svg.selectAll('.lines-area').length <= 1) {
      svg.append('g').attr('class', 'lines-area');
    }

    if(svg.selectAll('.dots-area').length <= 1) {
      svg.append('g').attr('class', 'dots-area');
    }
  }),

  svgHeight: computed('data.series.[]', function() {
    let height = 0;
    const series = get(this, 'data.series');

    let indexLine = 0;
    const lines = series.filterBy('type', 'line').filter((item) => item.data.length > 0).map((i) => {
      i.index = indexLine;
      indexLine += 1;
    });

    let indexMarker = 0;
    const markers = series.filterBy('type', 'marker').filter((item) => item.data.length > 0).map((i) => {
      i.index = indexMarker;
      indexMarker += 1;
    });

    if(lines.length > 0) {
      height += get(this, 'svgLineAreaHeight');
    }

    if(markers.length > 0) {
      markers.forEach(() => {
        height += 2 * get(this, 'svgLineOffset') + get(this, 'svgLineHeight');
      });
    }

    get(this, 'xScale').domain([
      get(this, 'startAt').startOf('day').toDate().getTime(),
      get(this, 'endAt').endOf('day').toDate().getTime(),
    ]);

    get(this, 'yScaleStatic').domain([0, 4]);

    const dynamicSeries = series.filterBy('subtype', 'dynamic');

    get(this, 'yScaleDynamic').domain([
      d3.min(dynamicSeries, (i) => d3.min(i.data, (d) => d.y)),
      d3.max(dynamicSeries, (i) => d3.max(i.data, (d) => d.y))
    ]);

    return height;
  }),

  svgChartHeigth: computed('svgHeight', function() {
    const margin = get(this, 'margin');

    return (get(this, 'svgHeight') - margin.top - margin.bottom);
  }),
});
