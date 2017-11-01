import Ember from 'ember';

/* global d3 */

const {
  get,
  set,
  computed,
  observer,
  Component,
  A,
} = Ember;

export default Component.extend({
  classNames: ['flaredown-svg-group'],

  svg: null,
  data: null,

  svgChartWidth: 500,
  svgLineAreaHeight: 150,
  svgLineOffset: 20,
  svgLineHeight: 3,
  startAt: null,
  endAt: null,
  margin: { top: 20, right: 0, bottom: 5, left: 0 }, //margin for charts
  backgroundMargin: { right: 10, left: 10 , top: 0 }, // for init-svg
  colorIds: A(),
  hasLines: false,

  init(){
    this._super(...arguments);

    const xScale = d3.time.scale().range([0, get(this, 'svgWidth')]);
    const yScaleStatic = d3.scale.linear().range([get(this, 'svgLineAreaHeight'), 0]);

    set(this, 'xScale', xScale);
    set(this, 'yScaleStatic', yScaleStatic);
  },

  didInsertElement() {
    this._super(...arguments);

    const svgCanvas = d3.select(this.element).select('svg');
    const svgBackgroundArea = svgCanvas.append('g').attr('class', 'background-area');
    const svg = svgCanvas.append('g').attr('class', 'offset');

    const margin = get(this, 'margin');
    svg.attr("transform", "translate(" + margin.left + "," + margin.top + ")"); // svg references to g

    const resize = () => {
      let svgSelection = this.$();
      if(svgSelection) {
        const width = this.$().width();
        const backgroundMargin = get(this, 'backgroundMargin');

        set(this, 'svgWidth', width);
        set(this, 'svgChartWidth', width - backgroundMargin.left - backgroundMargin.right);
      }
    };
    set(this, 'svgBackgroundArea', svgBackgroundArea);
    set(this, 'svg', svg);

    window.addEventListener("resize", resize);

    resize();
  },

  xScaleObserver: observer('svgWidth', 'svgChartWidth', function(){
    get(this, 'xScale').range([0, get(this, 'svgWidth')]);

    this.renderBackground();

    if(get(this, 'hasLines')) {
      this.renderYGrid();
    }
  }),

  svgBackgroundObserver: observer('svgBackgroundArea', function() {
    const svgBackgroundArea = get(this, 'svgBackgroundArea');

    if(!svgBackgroundArea) {
      return;
    }

    if(svgBackgroundArea.select('rect').empty()) {
      svgBackgroundArea.append('rect').attr('class', 'svg-background');
    }
  }),

  svgGroupObserver: observer('svg', function() {
    const svg = get(this, 'svg');

    if(!svg) {
      return;
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

  startAtOffset: computed('startAt', 'daysRangeOffset', function() {
    return moment(get(this, 'startAt')).subtract(get(this, 'daysRangeOffset'), 'days');
  }),

  svgHeight: computed('data.series.[]', function() {
    let height = 0;
    let filteredSeries = A();
    const series = get(this, 'data.series');

    const dynamicSeries = series.filterBy('subtype', 'dynamic');
    const lines = series.filterBy('type', 'line')
    const markers = series.filterBy('type', 'marker');
    const margin = get(this, 'margin');

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
      get(this, 'startAtOffset').startOf('day').toDate().getTime(),
      get(this, 'endAt').endOf('day').toDate().getTime(),
    ]);

    get(this, 'yScaleStatic').domain([0, 4]);

    height += margin.top + margin.bottom;

    return height || 0;
  }),

  svgChartHeigth: computed('svgHeight', function() {
    const margin = get(this, 'margin');

    return (get(this, 'svgHeight') - margin.top - margin.bottom);
  }),

  addChartAttributes(item_array) {
    let index = get(item_array, 'firstObject.subtype') === 'dynamic' ? 10 : 0;

    item_array.map((i) => {
      i.index = index;
      index += 1;
    })
  },

  renderBackground() {
    const backgroundMargin = get(this, 'backgroundMargin');
    const svgBackgroundArea = get(this, 'svgBackgroundArea');

    svgBackgroundArea.attr("transform", "translate(" + backgroundMargin.left + "," + backgroundMargin.top + ")");

    svgBackgroundArea
      .select('rect')
      .attr('class', 'svg-background')
      .attr('width', get(this, 'svgChartWidth'))
      .attr('height', get(this, 'svgHeight'));
  },

  renderYGrid() {
    const svg = get(this, 'svg');
    const yScaleGrid =  get(this, 'yScaleStatic');
    const gridArea = svg.select('g.grid-area');
    const backgroundMargin = get(this, 'backgroundMargin')

    let attr = {
      'class': 'yGrid',
      'x1'   : backgroundMargin.left,
      'x2'   : (get(this, 'svgWidth') - backgroundMargin.right),
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
