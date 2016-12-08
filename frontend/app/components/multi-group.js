import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['tags-group'],

  objects: Ember.computed('scope', function() {
    return this.store.query(this.get('modelName'), { scope: this.get('scope') });
  }),

  actions: {
    clickObj(obj) {
      this.get('onTagClicked')(obj);
    }
  }
});
