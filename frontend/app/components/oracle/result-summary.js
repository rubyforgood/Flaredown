import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  computed,
  Component,
} = Ember;

export default Component.extend(SearchableDropdown, {
  randomTrackables: computed(function() {
    return this.randomSearch('condition');
  }),

  performSearch(term, resolve, reject) {
    this
      .searchByTerm('condition', term)
      .then(function() { resolve(...arguments); }, reject);
  },

  actions: {
    addCondition(condition) {
      const name = get(condition, 'name');
      const model = get(this, 'model');
      const responce = get(model, 'responce');

      if (!responce.findBy('name', name)) {
        responce.pushObject({
          name,
          correction: 'selfAdded',
          confidence: 100,
        });

        model.save();
      }
    }
  },
});
