import Ember from 'ember';

const {
  Controller,
} = Ember;

export default Controller.extend({
  actions: {
    transitionToResult(oracleRequest) {
      this.transitionToRoute('oracle.result', oracleRequest);
    },
  },
});
