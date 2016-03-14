import Ember from 'ember';

export default Ember.Mixin.create({

  autosaveEnabled: true,

  autosaveCheckin: Ember.on('didInsertElement', function() {
    if (this.get('autosaveEnabled')) {
      this.saveCheckin();
    }
  }),

  saveCheckin: function() {
    if (this.get('isDestroyed') || this.get('isDestroying')) {
      return;
    }
    // Ember.Logger.debug('Checkin save scheduled');
    this.checkinSavePromise().then(savedCheckin => {
      if (Ember.isPresent(savedCheckin) &&
          !this.get('isDestroyed') &&
          !this.get('isDestroying')) {
        this.onCheckinSaved();
      }
    }, () => {
      Ember.Logger.error('An error occurred while saving checkin');
    }).finally(() => {
      if (!this.get('isDestroyed') &&
          !this.get('isDestroying')) {
        Ember.run.later(this, function() {
          this.saveCheckin();
        }, 2000);
      }
    });
  },

  checkinSavePromise: function() {
    return new Ember.RSVP.Promise((resolve, reject) => {
      var checkin = this.get('checkin');
      if (checkin.get('hasDirtyAttributes') || checkin.get('tagsChanged')) {
        checkin.save().then(savedCheckin => {
          Ember.Logger.debug('Checkin successfully saved');
          resolve(savedCheckin);
        }, () => {
          reject();
        });
      } else {
        resolve();
        // Ember.Logger.debug("No need to save checkin");
      }
    });
  },

  onCheckinSaved: function() {
    this.get('checkin').set('hasDirtyAttributes', false);
    this.get('checkin').set('tagsChanged', false);
  }

});
