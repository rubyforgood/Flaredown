import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['tags-group'],

  tags: Ember.computed('scope', function() {
    return this.store.query('tag', {scope: this.get('scope')});
  }),

  actions: {
    clickTag(tag) {
      this.get('onTagClicked')(tag);
    }
  }

});
