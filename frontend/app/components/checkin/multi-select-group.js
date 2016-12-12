import Ember from 'ember';

export default Ember.Component.extend({
  checkin: Ember.computed.alias('parentView.checkin'),

  relatedObjects: Ember.computed('checkin', function() {
    return this.get('checkin.' + this.get('relationName'));
  }),

  selectedObject: null,

  actions: {
    add(obj) {
      this.get('checkin').addObj(obj, this.get('idsKey'), this.get('relationName'));
      this.saveCheckin();
      this.set('selectedObject', null);
    },

    remove(obj) {
      this.get('checkin').removeObj(obj, this.get('idsKey'), this.get('relationName'));
      this.saveCheckin();
    },
  },

  saveCheckin() {
    if (this.get('checkin.hasDirtyAttributes')) {
      Ember.run.next(this, function() {
        this.get('checkin').save().then(() => {
          Ember.Logger.debug('Checkin successfully saved');
          this.get('checkin').set('hasDirtyAttributes', false);
        }, (error) => {
          this.get('checkin').handleSaveError(error);
        });
      });
    }
  },
});
