import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['health-graph'],

  store: Ember.inject.service(),

  setupModel: Ember.on('init',function(){
    this.get('store').findRecord('graph', 'health').then( graph => {
      this.set('model', graph);
    });
  }),

  series: Ember.computed('model', function() {
    return this.get('model.series');
  }),

  axis: Ember.computed('model', function() {
    return this.get('model.axis');
  })

});
