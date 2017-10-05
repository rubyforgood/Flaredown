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

  init(){
    this._super(...arguments);

    const xScale = d3.time.scale().range([0, get(this, 'svgChartWidth')]);
    const yScale = d3.scale.linear().range([get(this, 'svgLineAreaHeight'), 0]);



    set(this, 'xScale', xScale);
    set(this, 'yScale', yScale);
  }

  didInsertElement() {
    const svg = d3.selection(this.element).select('svg');
    const width = this.$().width();

    set(this, 'svgChartWidth', width);
    set(this, 'svg', svg);
  },

  xScaleObserver: observer('svgChartWidth', function(){
    get(this, 'xScale').range([0, get(this, 'svgChartWidth')]);
  }),

  yScaleObserver: observer('svgChartHeigth', function(){
    get(this, 'yScale').range([get(this, 'svgChartHeigth'), 0]);
  }),

  svgChartHeigth: computed('data.series', function() {
    const lineChartHeight = 300;
    const markerChartHeight = 30;

    let height = get(this, 'svgHeight');
    const series = get(this, 'data.series');
    const hasLines = series.filterBy('type', 'line').filter((item) => item.data.length > 0).length > 0;
    const markers = series.filterBy('type', 'marker').filter((item) => item.data.length > 0);

    if(hasLines) {
      height += get(this, 'svgLineAreaHeight');
    }

    markers.forEach(() => {
      height += 2 * get(this, 'svgLineOffset') + get(this, 'svgLineHeight');
    });

    get(this, 'xScale').domain([
      d3.min(series, (item) => d3.min(item.data, (d) => d.x)),
      d3.max(series, (item) => d3.max(item.data, (d) => d.x)),
    ]);

    return height;
  })
});
