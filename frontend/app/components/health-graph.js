import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['health-graph'],


  data: Ember.computed('model', function() {
    return {
      x: 'x',
      columns: [
        ['x', '2013-01-01', '2013-01-02', '2013-01-03', '2013-01-04','2013-01-05', '2013-01-06'],
        ['data1', 30, 200, 100, 400, 150, 250],
        ['data2', 130, 340, 200, 500, 250, 350]
      ]
    };
  }),

  axis: Ember.computed('model', function() {
    return {
      x: {
        type: 'timeseries',
        tick: {
          format: '%Y-%m-%d'
        }
      }
    };
  })

});
