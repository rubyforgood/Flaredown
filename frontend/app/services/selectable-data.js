import Ember from 'ember';

export default Ember.Service.extend({
  dataStore: Ember.inject.service('store'),

  countries: Ember.computed(function() {
    return this.get('dataStore').findAll('country');
  }),

  sexes: Ember.computed.sort('unsortedSexes', 'sexSorting'),
  sexSorting: ['rank'],
  unsortedSexes: Ember.computed(function() {
    return this.get('dataStore').findAll('sex');
  }),

});
