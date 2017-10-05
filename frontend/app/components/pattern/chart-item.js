import Ember from 'ember';

/* global d3 */

const {
  get,
  set,
  observer,
  Component
} = Ember;

export default Component.extend({
  svg: null,
  data: null,
  index: 1,
  width: 300,
  heigth: 150,

  isRendered: false,

  renderObserve: observer('svg', 'isRendered', function() {
    if(get(this, 'svg') && get(this, 'isRendered')) {
      this.renderChart();
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
          this.renderMarker(data.data);
          break;
        }
        default: {
          this.renderLine(data.data);
          break;
        }
      }
    } else {
      // TODO: render "No Data"
      console.log('No data!');
    }
  },

  renderMarker(data) {
    const svg = get(this, 'svg');
    const index = get(this, 'index');
    const width = get(this, 'width');
    const x = d3.time.scale().range([0, width]);
    const y = d3.scale.linear().range([get(this, 'heigth'), 0]);

    // const line = d3.svg.line()
    //   .x((d) => {
    //     moment(d.x).toDate().getTime();
    //   })
    //   .y(() => index);

    x.domain(d3.extent(data, (d) => moment(d.x).toDate().getTime() ));
    y.domain([0, d3.max(data, (d) => index)]);

    svg.append('path')
      .attr('class', 'line')
      .attr('d', `M0 ${y(index)} H ${width}`)
      .attr('stroke', 'black')
      .style('stroke-dasharray', ('3, 3'));

    svg.selectAll('dot')
      .data(data)
      .enter().append('circle')
      .attr('fill', 'red')
      .attr('r', 3.5)
      .attr('cx', (d) => x(moment(d.x).toDate().getTime()))
      .attr('cy', (d) => y(index));
  },

  renderLine(data) {
    const svg = get(this, 'svg');
  }

});
