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
  setProperties,
  Component,
  A,
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
  margin: { top: 10, right: 5, bottom: 5, left: 10 },
  marginOffset: 20,
  colorIds: A(),
  hasLines: false,

  init(){
    this._super(...arguments);

    const xScale = d3.time.scale().range([0, get(this, 'svgChartWidth')]);
    const yScaleStatic = d3.scale.linear().range([get(this, 'svgLineAreaHeight'), 0]);

    set(this, 'xScale', xScale);
    set(this, 'yScaleStatic', yScaleStatic);
  },

  didInsertElement() {
    this._super(...arguments);

    const svg = d3.select(this.element).select('svg').append('g').attr('class', 'offset');

    const margin = get(this, 'margin');

    svg.attr("transform", "translate(" + margin.left + "," + margin.top + ")"); // svg references to g

    const resize = () => {
      let svgSelection = this.$();
      if(svgSelection) {
        const width = this.$().width();

        set(this, 'svgWidth', width);
        set(this, 'svgChartWidth', width - margin.left - margin.right);
      }
    };
    set(this, 'svg', svg);

    window.addEventListener("resize", resize);

    resize();
  },

  xScaleObserver: observer('svgChartWidth', function(){
    get(this, 'xScale').range([0, get(this, 'svgChartWidth')]);

    if(get(this, 'hasLines')) {
      this.renderYGrid();
    }
  }),

  svgGroupObserver: observer('svg', function() {
    const svg = get(this, 'svg');

    if(!svg) {
      return;
    }

    if(svg.select('.legend-area').empty()) {
      svg.append('g').attr('class', 'legend-area');
    }

    if(svg.select('.grid-area').empty()) {
      svg.append('g').attr('class', 'grid-area');
    }

    if(svg.select('.lines-area').empty()) {
      svg.append('g').attr('class', 'lines-area');
    }

    if(svg.select('.dots-area').empty()) {
      svg.append('g').attr('class', 'dots-area').attr('transform', 'translate(0, 0)');
    }
  }),

  svgHeight: computed('data.series.[]', function() {
    let height = 0;
    let filteredSeries = A();
    const series = get(this, 'data.series');

    const dynamicSeries = series.filterBy('subtype', 'dynamic');
    const lines = series.filterBy('type', 'line')
    const markers = series.filterBy('type', 'marker');

    filteredSeries.pushObjects([lines, dynamicSeries, markers]).map((itemArray) => {
      return this.addChartAttributes(itemArray);
    });

    if(lines.length > 0 || dynamicSeries.length > 0) {
      height += get(this, 'svgLineAreaHeight') + get(this, 'svgLineOffset');
      set(this, 'hasLines', true);
    } else {
      height += get(this, 'svgLineOffset');
      set(this, 'svgLineAreaHeight', 0);
    }

    if(markers.length > 0) {
      markers.forEach(() => {
        height += get(this, 'svgLineHeight') + get(this, 'svgLineOffset');
      });
    }

    get(this, 'xScale').domain([
      get(this, 'startAt').startOf('day').toDate().getTime(),
      get(this, 'endAt').endOf('day').toDate().getTime(),
    ]);

    get(this, 'yScaleStatic').domain([0, 4]);

    return height;
  }),

  svgChartHeigth: computed('svgHeight', function() {
    const margin = get(this, 'margin');

    return (get(this, 'svgHeight') - margin.top - margin.bottom);
  }),

  addChartAttributes(item_array) {
    let index = 0;

    item_array.map((i) => {
      i.index = index;
      index += 1;
    })
  },

  renderYGrid() {
    const svg = get(this, 'svg');
    const hasDynamicSeries = get(this, 'data.series').filterBy('subtype', 'dynamic').length > 0;
    const yScaleGrid =  get(this, 'yScaleStatic');
    const gridArea = svg.select('g.grid-area');

    let attr = {
          'class': 'yGrid',
          'x1'   : get(this, 'margin.right'),
          'x2'   : get(this, 'svgChartWidth'),
          'y1'   : (d) => { return yScaleGrid(d) },
          'y2'   : (d) => { return yScaleGrid(d) },
        };

    let grid = gridArea.selectAll('.yGrid')
      .data(yScaleGrid.ticks(5))
      .attr(attr);

    grid.exit().remove();

    return grid.enter()
      .append('line')
        .attr(attr);
  },
});
