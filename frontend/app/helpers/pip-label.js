import Ember from 'ember';

export function pipLabel(params/*, hash*/) {
  var label = '';

  switch(params[0]) {
    case 0:
      label = "Very well";
      break;
    case 1:
      label = "Slightly below par";
      break;
    case 2:
      label = "Poor";
      break;
    case 3:
      label = "Very poor";
      break;
    case 4:
      label = "Terrible";
      break;
    default:
      label = "";
  }

  return label;
}

export default Ember.Helper.helper(pipLabel);
