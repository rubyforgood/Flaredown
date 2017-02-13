import Ember from 'ember';

const {
  get,
  set,
  Mixin,
  isEmpty,
  computed,
  getProperties,
} = Ember;

export default Mixin.create({
  tagName: 'g',
  classNames: 'chart',
  attributeBindings: ['transform'],

  transform: computed('height', 'padding', 'chartOffset', function() {
    return `translate(0,${get(this, 'chartOffset')})`;
  }),

  nestedTransform: computed('height', 'startAt', 'data', function() {
    return `translate(${ - get(this, 'xScale')( get(this, 'startAt') )}, 5)`;
  }),

  xDomain: computed('data', function() {
    return d3.extent(get(this, 'data'), d => d.x);
  }),

  xScale: computed('data', function() {
    return(
      d3
        .time
        .scale()
        .range([0, get(this, 'width')])
        .domain(get(this, 'xDomain'))
    );
  }),

  lineData: computed('data', function() {
    return get(this, 'data').reject(item => isEmpty(item.y));
  }),

  lineFunction: computed('lineData', function() {
    return(
      d3
        .svg
        .line()
        .x(this.getX.bind(this))
        .y(this.getY.bind(this))
        .interpolate('linear')
        (get(this, 'lineData'))
    );
  }),

  getX(d) {
    return get(this, 'xScale')(d.x);
  },

  getY(d) {
    return get(this, 'yScale')(d.y) - 4; // minus radius
  },

  actions: {
    openPointTooltip(point) {
      set(this, 'openPointTooltip', true);
      set(this, 'currentPoint', point);
    },

    closePointTooltip() {
      set(this, 'openPointTooltip', false);
      set(this, 'currentPoint', null);
    },

    hideChart() {
      const {
        name,
        category,
        chartsVisibilityService,
      } = getProperties(this, 'name', 'category', 'chartsVisibilityService');

      chartsVisibilityService.setVisibility(false, category, name);
    },
  }
});
