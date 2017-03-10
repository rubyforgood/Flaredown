import Ember from 'ember';

const {
  Component,
  inject: {
    service,
  },
  computed: {
    sort,
    alias,
  },
} = Ember;

export default Component.extend({
  selectableData: service('selectable-data'),

  countrySorting: ['name:asc'],

  sexes: alias('selectableData.sexes'),
  countries: sort('selectableData.countries', 'countrySorting'),

  actions: {
    askOracle(oracleRequest) {
      oracleRequest.askOracle();
    },
  },
});
