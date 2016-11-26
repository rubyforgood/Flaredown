import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

export default Ember.Component.extend(SearchableDropdown, {

  isSelectFocused: false,

  selectPlaceholder: Ember.computed('isSelectFocused', function() {
    if (this.get('isSelectFocused')) {
      return 'Start typing a tag';
    } else {
      return 'Add a tag';
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
    searchTags(term) {
      return this.searchByTerm('tag', term);
    },
    createTag(name) {
      this.createAndSave('tag', name).then(tag => {
        this.get('onSelected')(tag);
      });
    },
    handleChange(tag) {
      this.get('onSelected')(tag);
    },
    clicked(tag) {
      this.get('onClicked')(tag);
    }
  }

});
