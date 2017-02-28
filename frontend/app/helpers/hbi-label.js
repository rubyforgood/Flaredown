import Ember from 'ember';

export function hbiLabel(params/*, hash*/) {
  let score = params[0] || 0;

  if (score < 5) {
      return "This score indicates remission in Crohn's Disease";
    } else if (score < 8) {
      return "This score indicates mild Crohn's Disease";
    } else if (score < 17) {
      return "This score indicates moderate Crohn's Disease";
    }

  return "This score indicates severe Crohn's Disease";
}

export default Ember.Helper.helper(hbiLabel);
