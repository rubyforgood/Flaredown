import Ember from 'ember';

const {
  get,
  Route,
  inject : { service }
} = Ember;

export default Route.extend({
  ajax: service('ajax'),

  beforeModel(transition) {
    const notifyToken = transition.params.unsubscribe.notify_token;

    get(this, 'ajax').request(`/unsubscribe/${ notifyToken }`, {
      type: 'GET',
      data: transition.queryParams,
    });
  }
});
