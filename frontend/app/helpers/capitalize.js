import Ember from 'ember';

export function capitalize(params/*, hash*/) {
  if(params[0]) {
    return Ember.String.capitalize(params[0]);
  } else {
    return '';
  }
}

export default Ember.Helper.helper(capitalize);
