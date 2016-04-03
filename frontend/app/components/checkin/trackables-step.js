import Ember from 'ember';
import DS from 'ember-data';
import TrackablesFromType from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromType, {

  model: Ember.computed.alias('parentView.model'),

  stepControls: true,

  tracking: Ember.inject.service(),
  setupTracking: Ember.on('init', function() {
    this.get('tracking').setup({at: new Date()});
  }),

  checkin: Ember.computed.alias('model.checkin'),
  isTodaysCheckin: Ember.computed('checkin', function() {
    return moment(this.get('checkin.date')).isSame(new Date(), 'day');
  }),


  removedTracked: null,
  addedTracked: null,

  actions: {
    remove(tracked) {
      tracked.prepareForDestroy();
      this.set('removedTracked', tracked);
      this.get('checkin').set('hasDirtyAttributes', true);
      this.saveCheckin();
    },
    add(selectedTrackable) {
      // var selectedTrackable = this.get('selectedTrackable');
      if (Ember.isPresent(selectedTrackable.get('id'))) {
        this.shouldAddTrackable(selectedTrackable);
      } else {
        selectedTrackable.save().then( savedTrackable => {
          this.shouldAddTrackable(savedTrackable);
        });
      }
    },
    saveChanges() {
      this.get('checkin').set('hasDirtyAttributes', true);
      this.saveCheckin();
    },

    completeStep() {
      this.get('onStepCompleted')();
    },
    goBack() {
      this.get('onGoBack')();
    }
  },

  shouldAddTrackable(trackable) {
    if (this.get('trackeds.isFulfilled')) {
      this.addTrackable(this.get('trackeds.content'), trackable);
    } else {
      this.addTrackable(this.get('trackeds'), trackable);
    }
  },

  addTrackable(trackeds, trackable) {
    let trackableType = this.get('trackableType');
    // check if trackable is already present in this checkin
    var foundTrackable = trackeds.findBy(`${trackableType}.id`, trackable.get('id'));
    if (Ember.isNone(foundTrackable)) {
      let randomColor = Math.floor(Math.random()*32)+'';
      let recordAttrs = {colorId: randomColor};
      recordAttrs[trackableType] = trackable;
      let recordType = `checkin_${trackableType}`.camelize();
      let tracked = this.store.createRecord(recordType, recordAttrs);
      trackeds.pushObject(tracked);
      this.set('addedTracked', tracked);
      this.get('checkin').set('hasDirtyAttributes', true);
      this.saveCheckin();
    }
    this.set('selectedTrackable', null);
  },

  saveCheckin() {
    if (this.get('checkin.hasDirtyAttributes')) {
      Ember.run.next(this, function() {
        Ember.RSVP.all([
          this.untrackRemovedTracked(),
          this.trackAddedTracked()
        ]).then(() => {
          this.get('checkin').save().then(() => {
            Ember.Logger.debug('Checkin successfully saved');
            this.onCheckinSaved();
          }, (error) => {
            Ember.logger.error(error);
          });
        });
      });
    } else {
      // Ember.Logger.debug("No need to save checkin");
    }
  },

  onCheckinSaved() {
    this.deleteAddedTracked();
    this.get('checkin').set('hasDirtyAttributes', false);
    this.set('addedTracked', null);
    this.set('removedTracked', null);
  },

  untrackRemovedTracked() {
    // untrack() removedTracked if isTodaysCheckin
    return new Ember.RSVP.Promise(resolve => {
      let removedTracked = this.get('removedTracked');
      if (this.get('isTodaysCheckin') && Ember.isPresent(removedTracked)) {
        let rawTrackable = removedTracked.get(this.get('trackableType'));
        if (DS.PromiseObject.detectInstance(rawTrackable)) {
          let trackablePromise = rawTrackable;
          if (trackablePromise.get('isFulfilled')) {
            this.untrack(trackablePromise.get('content'), resolve);
          } else {
            trackablePromise.then(trackable => {
              this.untrack(trackable, resolve);
            });
          }
        } else {
          Ember.Logger.debug('rawTrackable is not a DS.PromiseObject');
          if (Ember.isPresent(rawTrackable)) {
            this.untrack(rawTrackable, resolve);
          }
        }
      } else {
        resolve();
      }
    });
  },

  untrack(trackable, resolve) {
    this.get('tracking').untrack(
      {
        trackable: trackable,
        trackableType: this.get('trackableType').capitalize()
      },
      resolve
    );
  },

  trackAddedTracked() {
    // track() addedTracked if isTodaysCheckin
    return new Ember.RSVP.Promise(resolve => {
      var addedTracked = this.get('addedTracked');
      if (this.get('isTodaysCheckin') && Ember.isPresent(addedTracked)) {
        let rawTrackable = addedTracked.get(this.get('trackableType'));
        if (DS.PromiseObject.detectInstance(rawTrackable)) {
          let trackablePromise = rawTrackable;
          if (trackablePromise.get('isFulfilled')) {
            this.get('tracking').track(
              trackablePromise.get('content'),
              addedTracked.get('colorId'),
              resolve
            );
          } else {
            trackablePromise.then(trackable => {
              this.get('tracking').track(
                trackable,
                addedTracked.get('colorId'),
                resolve
              );
            });
          }
        } else {
          Ember.Logger.debug('rawTrackable is not a DS.PromiseObject');
          if (Ember.isPresent(rawTrackable)) {
            this.get('tracking').track(
              rawTrackable,
              addedTracked.get('colorId'),
              resolve
            );
          }
        }
      } else {
        resolve();
      }
    });
  },

  deleteAddedTracked() {
    // remove addedTracked to avoid 'ghost' record
    let addedTracked = this.get('addedTracked');
    if (Ember.isPresent(addedTracked)) {
      addedTracked.deleteRecord();
    }
  }

});
