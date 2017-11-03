import Ember from 'ember';

/* global d3 */

const {
  get,
  set,
  computed,
  observer,
  Component,
  run: { scheduleOnce }
} = Ember;

export default Component.extend({
  data: null,
  chart: null,
  index: 1,
  isRendered: false,
  svgInitial: false,

  renderObserver: observer('chart.svg', 'chart.width', 'chart.height', 'isRendered', 'onNavigate', function() {
    if(get(this, 'chart.svg') && get(this, 'isRendered')) {
      scheduleOnce('afterRender', this, this.renderChart);
    }
  }),

  isCurrentEndDate: computed('chart.endAt', function() {
    return get(this, 'chart.endAt').startOf('day').toDate().getTime() == moment().startOf('day').toDate().getTime();
  }),

  didInsertElement() {
    this._super(...arguments);

    set(this, 'isRendered', true);
    set(this, 'yScaleDynamic', d3.scale.linear().range([get(this, 'chart.svgLineAreaHeight'), 0]));
  },

  renderChart() {
    const data = get(this, 'data');

    if(data.data) {
      switch(data.type) {
        case 'marker': {
          this.renderMarker(data.data, data.index, data.label);
          break;
        }
        default: {
          this.renderLine(data.data, data.subtype, data.index, data.label);
          break;
        }
      }
    } else {
      // TODO: render "No Data"
      // console.log('No data!');
    }
  },

  renderMarker(data, index, label) {
    const svg = get(this, 'chart.svg');
    const dotsAreas = svg.select('g.dots-area');

    const svgInitial = get(this, 'chart.svgInitial');
    const backgroundMarginRight = get(this, 'chart.backgroundMarginRight');

    const width = svgInitial ? get(this, 'chart.width') - 2*backgroundMarginRight : get(this, 'chart.width');
    const xScale = get(this, 'chart.xScale');
    const colorId = get(this, 'data.color_id');

    const y = get(this, 'chart.svgLineAreaHeight') + get(this, 'chart.svgLineOffset')*(index + 1) + get(this, 'chart.svgLineHeight')*index;

    const lineWidth = get(this, 'isCurrentEndDate') ? get(this, 'chart.svgChartWidth') : width;

    const lineData = [{x: 0, y: y, x2: width, y2: y}];
    const paths = dotsAreas
      .selectAll(`.dot-path-${index}`) // for adding new pathes
      .data(lineData)
      .attr('x1', 0)
      .attr('y1', y)
      .attr('x2', lineWidth)
      .attr('y2', y);

    paths.exit().remove();
    paths.enter()
      .append('line')
        .attr('class', `line colorable-stroke-${colorId} dot-path-${index}`)
        .attr('x1', 0)
        .attr('y1', y)
        .attr('x2', lineWidth)
        .attr('y2', y)
        .attr('stroke', `${colorId}`)
        .style('stroke-dasharray', ('3, 3'));

    const dots = dotsAreas
      .selectAll(`.dot-${index}`)
      .data(data)
      .attr('cx', (d) => xScale(moment(d.x).toDate().getTime()))
      .attr('cy', () => y);

    dots.enter()
      .append('circle')
        .attr('class', `colorable-fill-${colorId} dot-${index}`)
        .attr('r', 6)
        .attr('cx', (d) => {
          return xScale(moment(d.x).toDate().getTime());
          // return d.y == null ? null : xScale(moment(d.x).toDate().getTime());
        })
        .attr('cy', () => y)
        .attr('data-legend', () => {
          return label;
        });

      this.renderLabel(dotsAreas, label, colorId, `translate(50, ${155 + 25*index})`);

      dots.exit().remove();
  },

  renderLine(data, subtype, index, label) {
    const svg = get(this, 'chart.svg');
    const lineAreas = svg.selectAll('g.lines-area');

    const isStatic = subtype === 'static';
    const xScale = get(this, 'chart.xScale');
    let yScaleDynamic = get(this, 'yScaleDynamic');

    if(!isStatic) {
      if(label == 'Avg daily humidity') {
        yScaleDynamic.domain([0, 100]);
      } else if(label == 'Harvey Bradshaw Index') {
        yScaleDynamic.domain([0, 25]);
      } else {
        yScaleDynamic.domain([
          d3.min(data, (d) => d.y ),
          d3.max(data, (d) => d.y )
        ]);
      }
    }

    const yScale = isStatic ? get(this, 'chart.yScaleStatic') : yScaleDynamic;
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
        .attr('class', isStatic ? `line colorable-stroke-${colorId} line-path-${index}` : `line dynamic colorable-stroke-${colorId} line-path-${index}`)
        .attr('d', line(data))
        .attr('data-legend', () => {
          return label;
        });

    this.renderLabel(lineAreas, label, colorId, "translate(265, 80)");

    lines.exit().remove();

    const lineDotsAreas = svg.selectAll('g.lines-dots-area');
    const filteredData = data.filter((d) => !d.average);

    const dots = lineDotsAreas
      .selectAll(`.dot-line-${index}`)
      .data(filteredData)
      .attr('cx', (d) => xScale(moment(d.x).toDate().getTime()) )
      .attr('cy', (d) => yScale(moment(d.y).toDate().getTime()) );

    dots.enter()
      .append('circle')
        .attr('class', `colorable-stroke-${colorId} dot-line-${index}`)
        .attr('r', 4)
        .attr('stroke-width', 2)
        .attr('fill', 'white')
        .attr('cx', (d) => xScale(moment(d.x).toDate().getTime()) )
        .attr('cy', (d) => yScale(moment(d.y).toDate().getTime()) );

    dots.exit().remove();
  },

  renderLabel(selection, label, colorId, translate) {
    if(get(this, 'initialSvg')) {
      selection.append('text')
        .attr('x', get(this, 'width'))
        .attr("dy", ".35em")
        .text(label)
        .attr('transform', translate)
        .attr('class', `colorable-fill-${colorId}`);
    }
  },
});
