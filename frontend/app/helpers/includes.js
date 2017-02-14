import Ember from 'ember';

export function includes(params) {
  return params.slice(1).find(i => i === params[0]);
}

export default Ember.Helper.helper(includes);
