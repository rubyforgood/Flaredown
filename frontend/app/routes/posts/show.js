import Ember from 'ember';

const {
  get,
  set,
  Route,
} = Ember;

export default Route.extend({
  model(params) {
    return get(this, 'store').find('post', params.id);
  },

  setupController(controller, model) {
    this._super(controller, model);

    set(controller, 'newComment', get(this, 'store').createRecord('comment'));
  },
});
