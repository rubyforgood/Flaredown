import Ember from 'ember';

export function capitalize(params/*, hash*/) {
  return Ember.String.capitalize(params[0]);
}

export default Ember.Helper.helper(capitalize);
