import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

export default Ember.Component.extend(SearchableDropdown, {

  isSelectFocused: false,
  placeholder: Ember.computed('trackableType', 'isSelectFocused', function() {
    if (this.get('isSelectFocused')) {
      return 'Start typing a '+this.get('trackableType');
    } else {
      return 'Add a '+this.get('trackableType');
    }
  }),

  randomTrackables: Ember.computed('trackableType', function() {
    return this.randomSearch(this.get('trackableType'));
  }),

  actions: {
    createTrackable(name) {
      this.createAndSave(this.get('trackableType'), name).then(trackable => {
        this.get('onSelect')(trackable);
      });
    },
    handleChange(trackable) {
      this.get('onSelect')(trackable);
    },
    handleBuildSuggestion(typedText) {
      // TODO Return rendered component: power-select/dropdown-trackable-create
      return `Add ${this.get('trackableType')}: "${typedText}"`;
    },
    handleFocus() {
      // TODO remove debug log when this is fixed:
      // https://github.com/cibernox/ember-power-select/issues/739
      Ember.Logger.debug('focus');
      this.set('isSelectFocused', true);
    },
    handleBlur() {
      // TODO remove debug log when this is fixed:
      // https://github.com/cibernox/ember-power-select/issues/739
      Ember.Logger.debug('blur');
      this.set('isSelectFocused', false);
    },
  },

  performSearch(term, resolve, reject) {
    this
      .searchByTerm(this.get('trackableType'), term)
      .then(function() { resolve(...arguments) }, reject);
  }
});
