/* global d3 */
import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['health-graph'],

  store: Ember.inject.service(),

  setupModel: Ember.on('init',function(){
    this.get('store').queryRecord('graph', { id: 'health', start_at: "now", end_at: "now" }).then( graph => {
      this.set('model', graph);
      Ember.run.once(this, this.get('draw'));
    });
  }),

  viewport: Ember.computed(function() {
    return d3.select(this.$('.chart-viewport'));
  }),

  clearChart() {
    this.$('.chart-viewport').children().remove();
  },

  draw() {
    this.clearChart();
    this.get('model.series').forEach( (data) => {
      Ember.debug(data);
    })
  }

});
