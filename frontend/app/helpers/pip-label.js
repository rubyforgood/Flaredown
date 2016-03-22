import Ember from 'ember';

export function pipLabel(params/*, hash*/) {
  var label = '';

  switch(params[0]) {
    case 0:
      label = "Not active";
      break;
    case 1:
      label = "Slightly active";
      break;
    case 2:
      label = "Fairly active";
      break;
    case 3:
      label = "Very active";
      break;
    case 4:
      label = "Extremely active";
      break;
    default:
      label = "";
  }

  return label;
}

export default Ember.Helper.helper(pipLabel);
