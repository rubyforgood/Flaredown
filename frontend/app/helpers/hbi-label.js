import Ember from 'ember';

export function hbiLabel(params/*, hash*/) {
  let score = params[0] || 0;

  if (score < 5) {
      return 'Remission';
    } else if (score < 8) {
      return 'Mild disease';
    } else if (score < 17) {
      return 'Moderate disease';
    }

  return 'Severe disease';
}

export default Ember.Helper.helper(hbiLabel);
