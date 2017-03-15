import Ember from 'ember';

const {
  Component,
  computed: {
    alias,
  },
} = Ember;

export default Component.extend({
  sexes: alias('selectableData.sexes'),

  actions: {
    askOracle(oracleRequest) {
      oracleRequest.askOracle();
    },
  },
});
