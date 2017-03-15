import Ember from 'ember';

const {
  Component,
  inject: {
    service,
  },
  computed: {
    alias,
  },
} = Ember;

export default Component.extend({
  selectableData: service(),

  sexes: alias('selectableData.sexes'),

  actions: {
    askOracle(oracleRequest) {
      oracleRequest.askOracle();
    },
  },
});
