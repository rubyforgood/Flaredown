import Ember from 'ember';
import DS from 'ember-data';
import TrackablesFromType from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromType, {
  classNames: ['trackables-step'],

  model: Ember.computed.alias('parentView.model'),

  embeddedInSummary: false,

  tracking: Ember.inject.service(),
  setupTracking() {
    this.get('tracking').setup({
      at: new Date(this.get('checkin.date')),
      trackableType: this.get('trackableType').capitalize()
    });
  },

  checkin: Ember.computed.alias('model.checkin'),
  isTodaysCheckin: Ember.computed('checkin', function() {
    return moment(this.get('checkin.date')).isSame(new Date(), 'day');
  }),

  sortedTrackeds: Ember.computed('trackeds', 'trackeds.[]', 'trackeds.@each.position', function() {
    return this.get('trackeds').toArray().sortBy('position');
  }),

  didReceiveAttrs() {
    this._super(...arguments);
    this.set('step',
      this.store.findRecord('step', `checkin-${this.get('trackableType').pluralize()}`)
    );
    this.setupTracking();
  },

  removedTracked: null,
  addedTracked: null,

  actions: {
    remove(tracked) {
      tracked.prepareForDestroy();
      this.set('removedTracked', tracked);
      this.saveCheckin();
    },

    add(selectedTrackable) {
      if (Ember.isPresent(selectedTrackable.get('id'))) {
        this.shouldAddTrackable(selectedTrackable);
      } else {
        selectedTrackable.save().then( savedTrackable => {
          this.shouldAddTrackable(savedTrackable);
        });
      }
    },

    move(draggedId, droppedId) {
      // Return if the item has been dropped onto its own dropzone
      if (Ember.isEqual(draggedId, droppedId)) { return; }
      let sortedTrackeds = this.get('sortedTrackeds');
      let draggedItem = sortedTrackeds.findBy('id', draggedId);
      // draggedItem might not be found if it's dragged from a different
      // trackables' collection (this might happen in summary screen)
      if (Ember.isNone(draggedItem)) { return; }
      let draggedPosition = draggedItem.get('position');
      let droppedPosition = 0;
      if (Ember.isEqual(droppedId, 'after-last')) {
        droppedPosition = sortedTrackeds.get('length');
      } else {
        let droppedItem = sortedTrackeds.findBy('id', droppedId);
        droppedPosition = droppedItem.get('position');
      }
      // Return if the item has been dropped onto its next item's dropzone
      if (Ember.isEqual(droppedPosition, draggedPosition + 1)) { return; }
      if (draggedPosition > droppedPosition) {
        // Case 1: Item Moved Up
        // Shift down items between droppedPosition and draggedPosition
        for (let i = droppedPosition; i < draggedPosition; i++) {
          sortedTrackeds[i].set('position', i + 1);
        }
        draggedItem.set('position', droppedPosition);
      } else {
        // Case 2: Move Down
        // Shift up items between draggedPosition and droppedPosition
        for (let i = draggedPosition + 1; i < droppedPosition; i++) {
          sortedTrackeds[i].set('position', i - 1);
        }
        draggedItem.set('position', droppedPosition - 1);
      }
      this.set('clickedTrackableId', null);
      this.saveCheckin();
    },

    onTrackableClicked(trackableId) {
      if (Ember.isPresent(this.get('clickedTrackableId'))) {
        if (Ember.isEqual(trackableId, this.get('clickedTrackableId'))) {
          this.set('clickedTrackableId', null);
        } else {
          this.set('clickedTrackableId', trackableId);
        }
      } else {
        this.set('clickedTrackableId', trackableId);
      }
    },

    saveChanges() {
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
      let recordAttrs = {
        colorId: this.computeNewColorId(),
        position: trackeds.get('length')
      };
      recordAttrs[trackableType] = trackable;
      let recordType = `checkin_${trackableType}`.camelize();
      let tracked = this.store.createRecord(recordType, recordAttrs);
      trackeds.pushObject(tracked);
      this.set('addedTracked', tracked);
      this.saveCheckin();
    }
    this.set('selectedTrackable', null);
  },

  computeNewColorId() {
    var nColors = 32;
    let usedColorIds = this.get('checkin.allColorIds');
    // if all colors have been used
    if (usedColorIds.length >= nColors) {
      // re-use them again in the same order
      return usedColorIds[(usedColorIds.length % nColors)];
    } else {
      // return a random unused color
      let randomColor = '';
      do {
        randomColor = Math.floor(Math.random()*nColors)+'';
      } while (usedColorIds.contains(randomColor));
      return randomColor;
    }
  },

  saveCheckin() {
    this.get('checkin').set('hasDirtyAttributes', true);
    Ember.run.next(this, function() {
      Ember.RSVP.all([
        this.untrackRemovedTracked(),
        this.trackAddedTracked()
      ]).then(() => {
        this.get('checkin').save().then(() => {
          Ember.Logger.info('Checkin successfully saved');
          this.onCheckinSaved();
        }, (error) => {
          this.get('checkin').handleSaveError(error);
        });
      });
    });
  },

  onCheckinSaved() {
    this.deleteAddedTracked();
    let checkin = this.get('checkin');
    checkin.set('hasDirtyAttributes', false);
    checkin.deleteTrackablesPreparedForDestroy();
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
