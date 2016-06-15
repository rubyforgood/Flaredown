import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['flaredown-white-box'],

  didInsertElement() {
    this._super(...arguments);
    this.$('.note-textarea').keyup(() => {
      if (!this.get('saveScheduled')) {
        this.scheduleSave();
      }
    });
  },

  saveScheduled: false,

  scheduleSave() {
    this.set('saveScheduled', true);
    this.get('checkin').set('hasDirtyAttributes', true);
    Ember.run.later(this, function() {
      this.save();
    }, 2500);
  },

  save() {
    this.get('checkin').save().then(() => {
      this.set('saveScheduled', false);
      this.get('checkin').set('hasDirtyAttributes', false);
    }, (error) => {
      this.get('checkin').handleSaveError(error);
    });
  }

});
