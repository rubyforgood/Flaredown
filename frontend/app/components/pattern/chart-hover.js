import Ember from 'ember';

/* global d3 */

const {
  $,
  get,
  set,
  run,
  observer,
  Component,
  A,
} = Ember;

export default Component.extend({
  classNames: ['chart-hover-container'],
  svg: null,
  data: null,
  width: null,
  height: null,
  dateFormat: 'MMM D, YYYY',
  tooltipTopOffset: 11,
  tooltipLeftOffset: 5,

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
    const backgroundMargin = get(this, 'backgroundMargin');
    const hoverArea = get(this, 'hoverArea');

    hoverArea
    .attr("width", width)
    .attr("transform", "translate(" + backgroundMargin.left + "," + backgroundMargin.top + ")");
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
      .attr('y2', svgHight)
      .attr('transform', 'translate(0, -10)');

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
        if ($(event.toElement).closest('.tooltip-area').length === 0) {
          line.style("display", "none");
          tooltipArea.css('visibility', 'hidden');
        }
      })
      .on("mousemove", () => {
        run(this, this.mouseMove, event);
      })
      .on("touchmove", () => {
        run(this, this.mouseMove, event);
      })
      .on("touchstart", () => {
        line.style("display", 'block');
        tooltipArea.css('visibility', 'visible');
      });

    set(this, 'hoverArea', hoverArea);
  },

  mouseMove(e) {
    if (e instanceof $.Event) {
      return;
    }

    const xScale = get(this, 'xScale');
    const mouseX = e.offsetX || e.changedTouches[0].screenX; //d3.mouse(hoverArea.node())[0];
    const xValue = moment(xScale.invert(mouseX));

    if(this.isOutOfRangeDates(xValue)) {
      return;
    }

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

  isOutOfRangeDates(date) {
    const startAt = get(this, 'startAt').startOf('day');
    const endAt = get(this, 'endAt');

    return date < startAt || date > endAt;
  },

  showTooltip(xValue, x) {
    const xValueFormatted = xValue.format('YYYY-MM-DD');
    const tooltipData = this.tooltipData(xValueFormatted).filter((item) => !item.average);
    if(tooltipData.empty) {
      return;
    }

    const lineItemList = tooltipData.filter((item) => !item.marker || item.category == 'treatments').map((item) => {
      let value = this.tooltipItemValue(item);

      return `<div class="line-item">
         <span class="colorable-clr-${item.color_id}">${item.label}</span>
         <span>${value}</span>
       </div>`
    }).join(' ');


    let markerItemList = tooltipData.filter((item) => item.marker && item.category !== 'treatments' ).map((item) => {
      return `<div class="marker-item">
         <span class="colorable-clr-${item.color_id}">${item.label}</span>
       </div>`
    }).join(' ');

    const tooltipArea = get(this, 'tooltipArea');
    const hoverCenter = get(this, 'width')/2;
    const tooltipLeftOffset = get(this, 'tooltipLeftOffset');

    let tooltipLeft = x <= hoverCenter ? (x + tooltipLeftOffset) : (x - tooltipLeftOffset - tooltipArea.width() - get(this, 'backgroundMargin.left'));

    const tooltipHeader = `<div class="tooltip-header">
      <a href=/checkin?date=${xValueFormatted}>
        <b>${xValue.format(get(this, 'dateFormat'))}</b>
        <img src="/assets/nav_icons/arrow-right.svg">
      </a>
    </div>`

    tooltipArea
      .css('visibility', 'visible')
      .html(() => {
        return `${tooltipHeader}` + `<div class="tooltip-items">
          ${lineItemList}
          <div class="marker-items">${markerItemList}</div>
        </div>`;
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
        return item.category == 'treatments' ? `${item.y}` : null;
      } else {
        let y = item.y % 1 === 0 ? item.y : item.y.toFixed(1);
        return `${y}/4`;
      }
    } else {
      let units = "";

      if(item.category == "weathersMeasures") {
        units = item.label == "Avg daily humidity" ? '%' : 'mb';
      }

      return `${item.y}` + `${units}`;
    }
  },
});
