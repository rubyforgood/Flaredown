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

  modelObserver: observer('model.responce', function() {
    if (!get(this, 'model.responce')) {
      return;
    }

    const oracleRequest = get(this, 'model');

    setProperties(this, getProperties(oracleRequest, 'age', 'sexId', 'countryId', 'symptomIds'));
  }),
});
