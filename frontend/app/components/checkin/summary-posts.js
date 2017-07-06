import Ember from 'ember';

const {
  get,
  computed,
  inject: {
    service,
  },
  Component,
} = Ember;

export default Component.extend({
  store: service(),
  session: service(),
  classNames: ['summary-posts'],

  model: computed(function(){
    return get(this, 'store').query('post', { summary: true });
  }),
});
