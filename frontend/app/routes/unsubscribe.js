import Ember from 'ember';

const {
  get,
  Route,
  inject : { service }
} = Ember;

export default Route.extend({
  ajax: service('ajax'),

  beforeModel(transition) {
    var notify_token = transition.params.unsubscribe.notify_token;

    get(this, 'ajax').request(`/api/unsubscribe/${ notify_token }`, {
      type: 'GET'
    });
  }
});
