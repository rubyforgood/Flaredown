import Ember from 'ember';

export default Ember.Component.extend({

  selectPlaceholder: 'Start typing a tag',

  onSelected: function(tag) {
    this.get('onSelected')(tag);
  },

  actions: {
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
    clicked(tag) {
      this.get('onClicked')(tag);
    }
  }

});
