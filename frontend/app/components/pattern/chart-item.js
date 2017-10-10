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

  renderObserve: observer('chart.svg', 'chart.width', 'chart.height', 'isRendered', function() {
    if(get(this, 'chart.svg') && get(this, 'isRendered')) {
      scheduleOnce('afterRender', this, 'renderChart');
    }
  }),

  didInsertElement() {
    set(this, 'isRendered', true);
  },

  renderChart() {
    const data = get(this, 'data');

    if(data.data.length > 0) {
      switch(data.type) {
        case 'marker': {
          this.renderMarker(data.data, data.index);
          break;
        }
        default: {
          this.renderLine(data.data, data.subtype);
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
    const width = get(this, 'chart.width');
    const xScale = get(this, 'chart.xScale');
    const colorId = get(this, 'data.color_id');

    const y = get(this, 'chart.svgLineAreaHeight') + get(this, 'chart.svgLineOffset')*(index + 1) + get(this, 'chart.svgLineHeight')*index;

    svg.select('g.lines')
    .append('path')
      .attr('class', `line colorable-stroke-${colorId}`)
      .attr('d', `M0 ${y} H ${width}`)
      .attr('stroke', 'black')
      .style('stroke-dasharray', ('3, 3'));

    svg.select('g.dots')
    .selectAll('dot')
      .data(data)
      .enter().append('circle')
      .attr('class', `colorable-stroke-${colorId}`)
      .attr('r', 6)
      .attr('cx', (d) => xScale(moment(d.x).toDate().getTime()))
      .attr('cy', (d) => y);
  },

  renderLine(data, subtype) {
    const isStatic = subtype === 'static';
    const xScale = get(this, 'chart.xScale');
    const yScale = get(this,  isStatic ? 'chart.yScaleStatic' : 'chart.yScaleDynamic');
    const colorId = get(this, 'data.color_id');
    const svg = get(this, 'chart.svg');

    const line = d3.svg.line()
      .x((d) => xScale(moment(d.x).toDate().getTime()))
      .y((d) => yScale(d.y));

    svg.append('path')
      .attr('class', isStatic ? `line colorable-stroke-${colorId}` : 'line dynamic')
      // .attr('class', `colorable-stroke-${colorId}`)
      .attr('d', line(data));
  }

});
