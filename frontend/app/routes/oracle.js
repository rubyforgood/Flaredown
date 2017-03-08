import Ember from 'ember';

const {
  Route,
} = Ember;

export default Route.extend({
  queryParams: {
    age: { replace: true },
    sexId: { replace: true },
    countryId: { replace: true },
    symptomIds: { replace: true },
  },

  model() {
    return {
      showForm: true,
      oracleRequest: this.store.createRecord('oracleRequest', {}),
    };
  }
});
