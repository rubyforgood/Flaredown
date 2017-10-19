import Ember from 'ember';

/* global d3 */

const {
  get,
  set,
  run,
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
  svg: null,
  data: null,
  width: null,
  height: null,

  initObserver: observer('svg', 'height', function() {
    this._super(...arguments);

    const svg = get(this, 'svg');
    const height = get(this, 'height');

    if(!svg || !height) {
      return;
    }

    this.renderContainer(svg);
  }),

  renderContainer(svg){

    if(!svg.select('.hover-area').empty()){
      return;
    }

    const svgHight = get(this, 'height');
    const line = svg.append('line')
      .attr('class', 'hover-line')
      .attr('style', 'display:none;')
      .attr('y1', 0)
      .attr('y2', svgHight);

    set(this, 'line', line);

    const hoverArea = svg.append("rect")
        .attr("class", "hover-area")
        .attr("width", get(this, 'width'))
        .attr("height", svgHight)
        .style("fill", "none")
        .style("pointer-events", "all")
        .on("mouseover", function() { line.style("display", null); })
        .on("mouseout", function() { line.style("display", "none"); })
        .on("mousemove", () => {
          run(this, this.mouseMove);
        });

    set(this, 'hoverArea', hoverArea);
  },

  mouseMove() {
    const hoverArea = get(this, 'hoverArea');
    const xScale = get(this, 'xScale');
    const mouseX = d3.mouse(hoverArea.node())[0];
    const xValue = moment(xScale.invert(mouseX));

    if(xValue.hours() >= 12){
      xValue.add(1, 'days').startOf('day');
    } else {
      xValue.startOf('day');
    }

    const x = xScale(xValue.toDate().getTime());

    get(this, 'line')
      .attr('x1', x)
      .attr('x2', x);
  }
});
