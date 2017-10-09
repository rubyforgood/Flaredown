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

    const y = get(this, 'chart.svgLineAreaHeight') + get(this, 'chart.svgLineOffset')*(index + 1) + get(this, 'chart.svgLineHeight')*index;

    console.log('data: ', data, 'y: ', y, 'index: ', index);


    svg.select('g.lines')
    .append('path')
      .attr('class', 'line')
      .attr('d', `M0 ${y} H ${width}`)
      .attr('stroke', 'black')
      .style('stroke-dasharray', ('3, 3'));

    svg.select('g.dots')
    .selectAll('dot')
      .data(data)
      .enter().append('circle')
      .attr('fill', 'red')
      .attr('r', 3.5)
      .attr('cx', (d) => xScale(moment(d.x).toDate().getTime()))
      .attr('cy', (d) => y);
  },

  renderLine(data, subtype) {
    const isStatic = subtype === 'static';
    const xScale = get(this, 'chart.xScale');
    const yScale = get(this,  isStatic ? 'chart.yScaleStatic' : 'chart.yScaleDynamic');
    const svg = get(this, 'chart.svg');

    const line = d3.svg.line()
      .x((d) => xScale(moment(d.x).toDate().getTime()))
      .y((d) => yScale(d.y));

    svg.append('path')
      .attr('class', isStatic ? 'line' : 'line dynamic')
      .attr('d', line(data));
  }

});
