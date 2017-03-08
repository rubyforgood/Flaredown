import Ember from 'ember';

const {
  get,
  observer,
  Controller,
  getProperties,
  setProperties,
} = Ember;

export default Controller.extend({
  queryParams: ['age', 'sexId', 'countryId', 'symptomIds'],

  modelObserver: observer('model.oracleRequest.isNew', function() {
    if (get(this, 'model.oracleRequest.isNew')) {
      return;
    }

    const oracleRequest = get(this, 'model.oracleRequest');

    setProperties(this, getProperties(oracleRequest, 'age', 'sexId', 'countryId', 'symptomIds'));
  }),
});
