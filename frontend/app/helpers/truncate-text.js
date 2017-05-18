import Ember from 'ember';

export function truncateText(params, hash) {
  const text = params[0];
  const len = hash.limit;

  if (typeof text !== 'undefined') {
    if (len !== null && text.length > len) {
      return `${text.substr(0, len)}...`;
    } else {
      return text;
    }
  }
  return '';
}

export default Ember.Helper.helper(truncateText);
