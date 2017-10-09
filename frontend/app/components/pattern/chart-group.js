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
  classNames: ['flaredown-svg-group'],

  svg: null,
  data: null,
  svgHeight: 0,

  svgChartWidth: 500,
  svgLineAreaHeight: 300,
  svgLineOffset: 10,
  svgLineHeight: 3,
  startAt: null,
  endAt: null,

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
    const svg = d3.select(this.element).select('svg');
    const width = this.$().width();

    svg.append('g').attr('class', 'lines');
    svg.append('g').attr('class', 'dots');


    set(this, 'svgChartWidth', width);
    set(this, 'svg', svg);
  },

  xScaleObserver: observer('svgChartWidth', function(){
    get(this, 'xScale').range([0, get(this, 'svgChartWidth')]);
  }),

  svgChartHeigth: computed('data.series', function() {
    let height = get(this, 'svgHeight');
    const series = get(this, 'data.series');
    const hasLines = series.filterBy('type', 'line').filter((item) => item.data.length > 0).length > 0;

    let index = 0;
    const markers = series.filterBy('type', 'marker').filter((item) => item.data.length > 0).map((i) => {
      i.index = index;
      index += 1;
    });

    if(hasLines) {
      height += get(this, 'svgLineAreaHeight');
    }

    markers.forEach(() => {
      height += 2 * get(this, 'svgLineOffset') + get(this, 'svgLineHeight');
    });

    get(this, 'xScale').domain([
      get(this, 'startAt').toDate().getTime(),
      get(this, 'endAt').toDate().getTime(),
    ]);

    get(this, 'yScaleStatic').domain([0, 4]);

    const dynamicSeries = series.filterBy('subtype', 'dynamic');

    get(this, 'yScaleDynamic').domain([
      d3.min(dynamicSeries, (i) => d3.min(i.data, (d) => d.y)),
      d3.max(dynamicSeries, (i) => d3.max(i.data, (d) => d.y))
    ]);

    return height;
  })
});
