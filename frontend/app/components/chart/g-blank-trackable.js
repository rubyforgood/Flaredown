import Ember from 'ember';
import Graphable from 'flaredown/components/chart/graphable';
import * as d3 from "d3";

const {
  computed,
  Component,
  computed: { alias },
} = Ember;

export default Component.extend(Graphable, {
  yRulers: [0, 1, 2, 3, 4],

  name: alias('model.name'),

  yScale: computed('data', function() {
    return d3.scale.linear().range([this.get('height') , 0]).domain([-1, 5]);
  }),

  data: computed('timeline', function() {
    return (this.get('timeline') || []).map(day => ({ x: day, y: null })).sortBy('x');
  }),
});
