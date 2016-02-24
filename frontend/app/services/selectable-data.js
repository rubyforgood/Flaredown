import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service(),

  countries: Ember.computed(function() {
    return this.get('store').findAll('country');
  }),

  sexes: Ember.computed.sort('unsortedSexes', 'sexSorting'),
  sexSorting: ['rank'],
  unsortedSexes: Ember.computed(function() {
    return this.get('store').findAll('sex');
  }),

  conditions: Ember.computed(function() {
    return this.get('store').findAll('condition');
  }),

  symptoms: Ember.computed(function() {
    return this.get('store').findAll('symptom');
  }),

  treatments: Ember.computed(function() {
    return this.get('store').findAll('treatment');
  })

});
