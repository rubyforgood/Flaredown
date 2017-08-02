import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

export default Ember.Component.extend(SearchableDropdown, {
  isSelectFocused: false,

  selectPlaceholder: Ember.computed('isSelectFocused', function() {
    if (this.get('isSelectFocused')) {
      return 'Start typing a ' + this.get('modelName');
    } else {
      return 'Add a ' + this.get('modelName');
    }
  }),

  actions: {
    toggleSelectFocused() {
      this.toggleProperty('isSelectFocused');
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

    createObject(name) {
      this.sendAction('onBeforeAdd', name);
      this.createAndSave(this.get('modelName'), name).then(obj => this.get('onSelected')(obj));
    },

    handleChange(obj) {
      this.get('onSelected')(obj);
    },

    clicked(obj) {
      this.get('onClicked')(obj);
    },
  },

  performSearch(term, resolve, reject) {
    this
      .searchByTerm(this.get('modelName'), term)
      .then(function() { resolve(...arguments); }, reject);
  },
});
