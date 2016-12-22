import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['flaredown-white-box'],

  saveScheduled: false,

  keyUp() {
    this.set('saveScheduled', true);
    this.get('checkin').set('hasDirtyAttributes', true);

    Ember.run.debounce(this, this.save, 2500);
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
