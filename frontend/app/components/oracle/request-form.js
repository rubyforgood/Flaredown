import Ember from 'ember';

const {
  get,
  set,
  Component,
  inject: {
    service,
  },
  getProperties,
  computed: {
    alias,
  },
} = Ember;

export default Component.extend({
  minSpinner: 3000,
  maxSpinner: 5000,
  selectableData: service(),
  oracleSpinnerVisible: false,

  sexes: alias('selectableData.sexes'),

  actions: {
    askOracle(oracleRequest) {
      set(this, 'oracleSpinnerVisible', true);

      const begin = + new Date();

      oracleRequest
        .askOracle()
        .then(() => oracleRequest.save())
        .then((result) => {
          localStorage.oracleToken = get(result, 'token');

          const { minSpinner, maxSpinner } = getProperties(this, 'minSpinner', 'maxSpinner');

          let timeout = Math.random() * (maxSpinner - minSpinner) + minSpinner - new Date() + begin;

          setTimeout(() => get(this, 'transitionToResult')(oracleRequest), timeout > 0 ? timeout : 0);
        });
    },
  },
});
