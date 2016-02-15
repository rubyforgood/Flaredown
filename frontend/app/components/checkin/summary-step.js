import Ember from 'ember';
import RunEvery from 'flaredown/mixins/run-every';

export default Ember.Component.extend(RunEvery, {

  model: Ember.computed.alias('parentView.model'),
  checkin: Ember.computed.alias('model.checkin'),

  savingConditions: false,
  savingSymptoms: false,
  savingTreatments: false,

  autosaveCheckin: Ember.on('init', function() {
    this.runEvery(2, () => {
      this.saveCheckin();
    });
  }),

  isSaving: false,
  saveCheckin: function() {
    this.checkinSavePromise().then(() => {
      this.onCheckinSaved();
    });
  },
  checkinSavePromise: function() {
    return new Ember.RSVP.Promise(resolve => {
      var checkin = this.get('checkin');
      if (!(this.get('isSaving') ||
            this.get('savingConditions') ||
            this.get('savingSymptoms') ||
            this.get('savingTreatments')) &&
          Ember.isPresent(checkin) &&
          (checkin.get('hasDirtyAttributes') || checkin.get('tagsChanged'))) {
        this.set('isSaving', true);
        checkin.save().then(() => {
          resolve();
        });
      } else {
        // Ember.Logger.debug("No need to save checkin");
      }
    });
  },
  onCheckinSaved: function() {
    Ember.Logger.debug('Checkin successfully saved');
    if (this.get('isDestroyed') || this.get('isDestroying')) {
      return;
    } else {
      this.get('checkin').set('tagsChanged', false);
      this.set('isSaving', false);
    }
  },

  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    }
  }

});
