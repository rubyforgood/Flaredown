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
    if(Ember.isPresent(this.get('model'))) {
      return this.get('model.series');
    } else {
      return { x: 'timeline', columns: [] }
    }
  }),

  axis: Ember.computed( function() {
    return{
      y: { show: false },
      x: {
        type: 'timeseries',
        tick: {
          format: '%Y-%m-%d'
        }
      }
    }
  })

});
