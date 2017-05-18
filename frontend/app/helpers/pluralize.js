import Ember from 'ember';

const { String: { pluralize } } = Ember;

export function pluralizeWord(params, options) {
  let [count, word] = params;
  const { omitCount } = options;

  if (count !== 1) {
    count = count || 0;
    word = pluralize(word);
  }

  return (omitCount ? '' : count + ' ') + word;
}

export default Ember.Helper.helper(pluralizeWord);
