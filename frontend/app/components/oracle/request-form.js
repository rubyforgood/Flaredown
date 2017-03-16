import Ember from 'ember';

const {
  get,
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
      oracleRequest
        .askOracle()
        .then(() => oracleRequest.save())
        .then(() => get(this, 'transitionToResult')(oracleRequest));
    },
  },
});
