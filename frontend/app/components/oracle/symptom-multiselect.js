import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  computed,
  Component,
  computed: {
    alias,
  },
} = Ember;

export default Component.extend(SearchableDropdown, {
  objects: alias('model.symptoms'),

  randomTrackables: computed(function() {
    return this.randomSearch('symptom');
  }),

  performSearch(term, resolve, reject) {
    this
      .searchByTerm('symptom', term)
      .then(function() { resolve(...arguments); }, reject);
  },

  actions: {
    add(object) {
      get(this, 'model').addSymptom(object);
    },

    remove(object) {
      get(this, 'model').removeSymptom(object);
    },
  },
});
