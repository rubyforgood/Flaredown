import Ember from 'ember';

/* global d3 */

const {
  get,
  set,
  observer,
  Component,
  run: { scheduleOnce }
} = Ember;

export default Component.extend({
  data: null,
  chart: null,
  index: 1,
  isRendered: false,

  renderObserver: observer('chart.svg', 'chart.width', 'chart.height', 'isRendered', 'onNavigate', function() {
    if(get(this, 'chart.svg') && get(this, 'isRendered')) {
      scheduleOnce('afterRender', this, this.renderChart);
    }
  }),

  didInsertElement() {
    this._super(...arguments);

    set(this, 'isRendered', true);
  },

  renderChart() {
    const svg = get(this, 'chart.svg');
    const data = get(this, 'data');

    if(data.data) {
      switch(data.type) {
        case 'marker': {
          this.renderMarker(data.data, data.index);
          break;
        }
        default: {
          this.renderLine(data.data, data.subtype, data.index);
          break;
        }
      }
    } else {
      // TODO: render "No Data"
      console.log('No data!');
    }
  },

  renderMarker(data, index) {
    const svg = get(this, 'chart.svg');
    const dotsAreas = svg.select('g.dots-area');
    const width = get(this, 'chart.width');
    const xScale = get(this, 'chart.xScale');
    const colorId = get(this, 'data.color_id') || 'black';

    const y = get(this, 'chart.svgLineAreaHeight') + get(this, 'chart.svgLineOffset')*(index + 1) + get(this, 'chart.svgLineHeight')*index;

    const lineData = [{x: 0, y: y, x2: width, y2: y}];
    const paths = dotsAreas
      .selectAll(`.dot-path-${index}`) // for adding new pathes
      .data(lineData)
      .attr('x1', 0)
      .attr('y1', y)
      .attr('x2', width)
      .attr('y2', y);

    paths.exit().remove();
    paths.enter()
      .append('line')
        .attr('class', `line colorable-stroke-${colorId} dot-path-${index}`)
        .attr('x1', 0)
        .attr('y1', y)
        .attr('x2', width)
        .attr('y2', y)
        .attr('stroke', `${colorId}`)
        .style('stroke-dasharray', ('3, 3'));

    const dots = dotsAreas
      .selectAll(`.dot-${index}`)
      .data(data)
      .attr('cx', (d) => xScale(moment(d.x).toDate().getTime()))
      .attr('cy', (d) => y);

    dots.enter()
      .append('circle')
        .attr('class', `colorable-stroke-${colorId} dot-${index}`)
        .attr('r', 6)
        .attr('cx', (d) => xScale(moment(d.x).toDate().getTime()))
        .attr('cy', (d) => y);

      dots.exit().remove();
  },

  renderLine(data, subtype, index) {
    const svg = get(this, 'chart.svg');
    const lineAreas = svg.selectAll('g.lines-area');

    const isStatic = subtype === 'static';
    const xScale = get(this, 'chart.xScale');
    const yScale = get(this,  isStatic ? 'chart.yScaleStatic' : 'chart.yScaleDynamic');
    const colorId = get(this, 'data.color_id');

    const line = d3.svg.line()
      .x((d) => xScale(moment(d.x).toDate().getTime()))
      .y((d) => yScale(d.y));

    const lines = lineAreas
    .selectAll(`.line-path-${index}`)
      .data(data)
      .attr('d', line(data));

    lines.enter()
      .append('path')
        .attr('class', isStatic ? `line colorable-stroke-${colorId} line-path-${index}` : 'line dynamic line-path-${index}')
        .attr('d', line(data));

    lines.exit().remove();
  }
});
