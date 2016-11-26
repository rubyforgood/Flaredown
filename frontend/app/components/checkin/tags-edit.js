import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

export default Ember.Component.extend(SearchableDropdown, {

  selectPlaceholder: Ember.computed('isSelectFocused', function() {
    if (this.get('isSelectFocused')) {   //TODO: make this work with EPS
      return 'Start typing a tag';
    } else {
      return 'Add a tag';
    }
  }),

  actions: {
    toggleSelectFocused() {
      this.toggleProperty('isSelectFocused');
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
