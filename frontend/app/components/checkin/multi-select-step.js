import Ember from 'ember';

export default Ember.Component.extend({
  model: Ember.computed.alias('parentView.model'),
  checkin: Ember.computed.alias('model.checkin'),

  relatedObjects: Ember.computed('checkin', function() {
    return this.get('checkin.' + this.get('relationName'));
  }),

  didReceiveAttrs() {
    this._super(...arguments);
    this.set('step', this.store.findRecord('step', arguments[0].newAttrs.step));
  },

  embeddedInSummary: false,
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

    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
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
