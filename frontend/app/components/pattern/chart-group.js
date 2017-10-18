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

    this.renderYGrid();
  }),

  svgGroupObserver: observer('svg', function() {
    const svg = get(this, 'svg');

    if(!svg) {
      return;
    }

    if(svg.selectAll('.y-grid').length <= 1) {
      svg.append('g').attr('class', 'grid-area');
    }

    if(svg.selectAll('.lines-area').length <= 1) {
      svg.append('g').attr('class', 'lines-area');
    }

    if(svg.selectAll('.dots-area').length <= 1) {
      svg.append('g').attr('class', 'dots-area').attr('transform', 'translate(0, 0)');
    }
  }),

  svgHeight: computed('data.series.[]', function() {
    let height = 0;
    const series = get(this, 'data.series');

    let indexLine = 0;
    const lines = series.filterBy('type', 'line').map((i) => {
      if(!i.color_id) {
        i.color_id = this.setColorId();
      };

      i.index = indexLine;
      indexLine += 1;
    });

    let indexMarker = 0;
    const markers = series.filterBy('type', 'marker').map((i) => {
      if(!i.color_id) {
        i.color_id = this.setColorId();
      };

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

    let yAxisStatic = d3.svg.axis()
      .scale(get(this, 'yScaleStatic'))
      .orient('left');

    let yAxisDynamic = d3.svg.axis()
      .scale(get(this, 'yScaleDynamic'))
      .orient('left');

    setProperties(this, { yAxisStatic: yAxisStatic, yAxisDynamic: yAxisDynamic });

    return height;
  }),

  svgChartHeigth: computed('svgHeight', function() {
    const margin = get(this, 'margin');

    return (get(this, 'svgHeight') - margin.top - margin.bottom);
  }),

  renderYGrid() {
    const svg = get(this, 'svg');
    const yScaleStatic = get(this, 'yScaleStatic');
    const gridArea = svg.select('g.grid-area');

    let grid = gridArea.selectAll('.yGrid').data(yScaleStatic.ticks(5));

    grid.enter()
      .append('line')
        .attr({
          'class': 'yGrid',
          'x1'   : get(this, 'margin.right'),
          'x2'   : get(this, 'svgChartWidth'),
          'y1'   : (d) => { return yScaleStatic(d) },
          'y2'   : (d) => { return yScaleStatic(d) },
        });
  },

  setColorId() {
    return get(this, 'colorIds').shiftObject();
  },
});
