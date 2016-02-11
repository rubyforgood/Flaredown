import Ember from 'ember';

export default Ember.Component.extend({

  tags: Ember.computed.alias('checkin.tags'),

  selectPlaceholder: 'Add tag',

  addTag: function(tag) {
    this.get('checkin').addTag(tag);
    this.set('selectedTag', null);
  },

  actions: {
    add() {
      var selectedTag = this.get('selectedTag');
      // if it's a new tag, create it first and then add to checkin
      if (Ember.isNone(selectedTag.get('id'))) {
        selectedTag.save().then(tag => {
          this.addTag(tag);
        });
      } else {
        this.addTag(selectedTag);
      }
    },
    remove(tag) {
      this.get('checkin').removeTag(tag);
    }
  }

});
