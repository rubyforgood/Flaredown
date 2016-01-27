import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['health-graph'],

  series: Ember.computed('model', function() {
    return this.get('model.series');
  }),

  axis: Ember.computed('model', function() {
    return this.get('model.axis');
  })

});
