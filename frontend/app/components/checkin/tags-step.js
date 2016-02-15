import Ember from 'ember';
import RunEvery from 'flaredown/mixins/run-every';

export default Ember.Component.extend(RunEvery, {

  model: Ember.computed.alias('parentView.model'),
  checkin: Ember.computed.alias('model.checkin'),

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
      if (!this.get('isSaving') && Ember.isPresent(checkin) && checkin.hasChanged()) {
        this.set('isSaving', true);
        checkin.save().then(() => {
          resolve();
        });
      } else {
        Ember.Logger.debug("Checkin didn't change, no need to save");
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
      this.saveCheckin();
      this.get('onStepCompleted')();
    },
    goBack() {
      this.saveCheckin();
      this.get('onGoBack')();
    }
  }

});
