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
    let remindQueryParam = transition.queryParams;

    const queryParams = Object.keys(remindQueryParam).map((key) => {
        return `${ key }=${ remindQueryParam[key] }`;
      }).join('&');
    debugger;
    get(this, 'ajax').request(`/unsubscribe/${ notify_token }`, {
      type: 'GET',
      data: transition.queryParams,
    });
  }
});
