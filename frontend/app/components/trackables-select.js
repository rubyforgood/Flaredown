import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  Component,
  computed,
} = Ember;

export default Component.extend(SearchableDropdown, {
  placeholder: computed('trackableType', function() {
    return `Add a ${get(this, 'trackableType')}`;
  }),

  randomTrackables: computed('trackableType', function() {
    return this.randomSearch(get(this, 'trackableType'));
  }),

  actions: {
    createTrackable(name) {
      const type = get(this, 'trackableType');

      this.createAndSave(type, name).then((trackable) => {
        this.sendAction('onSelect', trackable);
      });
    },

    handleChange(trackable) {
      this.sendAction('onSelect', trackable);
    },

    handleBuildSuggestion(typedText) {
      // TODO Return rendered component: power-select/dropdown-trackable-create
      return `Add ${this.get('trackableType')}: "${typedText}"`;
    },
  },

  performSearch(term, resolve, reject) {
    this
      .searchByTerm(this.get('trackableType'), term)
      .then(resolve, reject);
  },
});
