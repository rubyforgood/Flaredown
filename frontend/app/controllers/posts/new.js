import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  computed,
  Controller,
} = Ember;

export default Controller.extend(SearchableDropdown, {
  randomTrackables: computed(function() {
    return this.randomSearch('topic');
  }),

  performSearch(term, resolve, reject) {
    this
      .searchByTerm('topic', term)
      .then(function() { resolve(...arguments); }, reject);
  },

  actions: {
    addTopic() {

    },

    savePost() {
      get(this, 'model').save();
    },
  },
});
