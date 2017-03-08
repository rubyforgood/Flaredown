import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  set,
  computed,
  Component,
  getProperties,
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
    remove(object) {
      const model = get(this, 'model');

      get(model, 'symptoms').removeObject(object);
      get(model, 'symptomIds').removeObject(get(object, 'id'));
    },

    add(object) {
      const model = get(this, 'model');

      if (!get(model, 'symptoms')) {
        set(model, 'symptoms', []);
      }

      if (!get(model, 'symptomIds')) {
        set(model, 'symptomIds', []);
      }

      const { symptoms, symptomIds } = getProperties(model, 'symptoms', 'symptomIds');

      if (!symptoms.includes(object)) {
        symptoms.pushObject(object);
        symptomIds.pushObject(get(object, 'id'));
      }
    },
  },
});
