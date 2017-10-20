import Ember from 'ember';

/* global d3 */

const {
  $,
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
  dateFormat: 'MMM D, YYYY',
  tooltipTopOffset: 11,
  tooltipLeftOffset: 20,

  initObserver: observer('svg', 'height', 'width', function() {
    this._super(...arguments);

    const svg = get(this, 'svg');
    const height = get(this, 'height');

    if(!svg || !height) {
      return;
    }

    this.renderContainer(svg);
  }),

  widthObserver: observer('width', function() {
    const width = get(this, 'width');
    let hoverArea = get(this, 'hoverArea');

    hoverArea.attr('width', width);
  }),

  renderContainer(svg, width){
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

    const tooltipArea = this.$('.tooltip-area');
    set(this, 'tooltipArea', tooltipArea);

    const hoverArea = svg.append("rect")
      .attr("class", "hover-area")
      .attr("width", get(this, 'width'))
      .attr("height", svgHight)
      .style("fill", "none")
      .style("pointer-events", "all")
      .on("mouseover", function() {
          line.style("display", 'block');
          tooltipArea.css('visibility', 'visible');
      })
      .on("mouseout", function() {
        if (event.toElement !== tooltipArea.get(0)) {
          line.style("display", "none");
          tooltipArea.css('visibility', 'hidden');
        }
      })
      .on("mousemove", () => {
        run(this, this.mouseMove, event);
      });

    set(this, 'hoverArea', hoverArea);
  },

  mouseMove(e) {
    if (e instanceof $.Event) {
      return;
    }

    const hoverArea = get(this, 'hoverArea');
    const xScale = get(this, 'xScale');

    const mouseX = e.offsetX; //d3.mouse(hoverArea.node())[0];
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

    this.showTooltip(xValue, x);
    e.stopPropagation();
  },

  showTooltip(xValue, x) {
    const svg = get(this, 'svg');
    const width = get(this, 'width');
    const tooltipData = this.tooltipData(xValue.format('YYYY-MM-DD'));

    let itemList = tooltipData.map((item) => {
      let value = this.tooltipItemValue(item);

      return `<div class="tooltip-items"> \
          <div class="item"> \
            <span class="colorable-clr-${item.color_id}">${item.label}</span> \
            <span>${value}</span>
          </div> \
        </div>`
    }).join(' ');

    const tooltipArea = get(this, 'tooltipArea');
    const hoverCenter = get(this, 'width')/2;
    const tooltipWidth = tooltipArea.width();
    let tooltipLeft = x <= hoverCenter ? (x + get(this, 'tooltipLeftOffset')) : (x - tooltipArea.width() - 10);

    tooltipArea
      .css('visibility', 'visible')
      .html(() => {
        return `<b>${xValue.format(get(this, 'dateFormat'))}</b>` + itemList;
      })
      .css('top', get(this, 'tooltipTopOffset'))
      .css('left', tooltipLeft);
  },

  tooltipData(xValueFormatted) {
    let filteredItems = A();
    get(this, 'data.series').map((item) => {
      let filteredByDate = item.data.filterBy('x', xValueFormatted);

      if(filteredByDate.length == 0) {
        return;
      } else {
        let element = filteredByDate[0];
        element.label = item.label;
        element.color_id = item.color_id;
        element.marker = item.type == 'marker';
        element.static = item.subtype == 'static';
        element.category = item.category;

        return filteredItems.pushObjects(filteredByDate);
      }
    });

    return filteredItems;
  },

  tooltipItemValue(item) {
    if(item.static) {
      if(item.marker) {
        return item.category == 'treatments' ? `${item.y}` : '';
      } else {
        return `${item.y}/5`;
      }
    } else {
      return `${item.y}`;
    }
  },
});
