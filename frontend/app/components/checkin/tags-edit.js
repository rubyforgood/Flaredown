import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

export default Ember.Component.extend(SearchableDropdown, {

  selectPlaceholder: Ember.computed('isSelectFocused', function() {
    if (this.get('isSelectFocused')) {
      return 'Start typing a tag';
    } else {
      return 'Add a tag';
    }
  }),

  onSelected: function(tag) {
    this.get('onSelected')(tag);
  },

  actions: {
    toggleSelectFocused() {
      this.toggleProperty('isSelectFocused');
    },
    selected(selectedTag) {
      // if it's a new tag, create it first and then pass it to upper action
      if (Ember.isNone(selectedTag.get('id'))) {
        selectedTag.save().then(tag => {
          this.onSelected(tag);
        });
      } else {
        this.onSelected(selectedTag);
      }
    },
    searchTags(term) {
      return this.searchByTerm('tag', term);
    },
    handleChange() {
      Ember.Logger.debug('TODO');
    },
    clicked(tag) {
      this.get('onClicked')(tag);
    }
  }

});
