/* global moment */
import Ember from 'ember';
import TrackablesFromType from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromType, {

  model: Ember.computed.alias('parentView.model'),

  tracking: Ember.inject.service(),
  setupTracking: Ember.on('init', function() {
    this.get('tracking').setup({
      at: new Date(),
      trackableType: this.get('trackableType').capitalize()
    })
  }),

  checkin: Ember.computed.alias('model.checkin'),
  isTodaysCheckin: Ember.computed('checkin', function() {
    return moment(this.get('checkin.date')).isSame(new Date(), 'day');
  }),

  store: Ember.inject.service(),

  removedTrackeds: Ember.A([]),
  addedTrackeds: Ember.A([]),

  actions: {

    remove(tracked) {
      tracked.prepareForDestroy();
      this.get('removedTrackeds').pushObject(tracked);
    },
    add() {
      var selectedTrackable = this.get('selectedTrackable');
      if (Ember.isPresent(selectedTrackable.get('id'))) {
        this.addTrackable(selectedTrackable);
      } else {
        selectedTrackable.save().then( savedTrackable => {
          this.addTrackable(savedTrackable);
        });
      }
    },

    completeStep() {
      this.saveCheckin();
      this.get('onStepCompleted')();
    },
    goBack() {
      this.saveCheckin();
      this.get('onGoBack')();
    }
  },

  addTrackable: function(trackable) {
    var trackableType = this.get('trackableType');
    // check if trackable is already present in this checkin
    var foundTrackable = this.get('trackeds').findBy(`${trackableType}.id`, trackable.get('id'));
    if (Ember.isNone(foundTrackable)) {
      var randomColor = Math.floor(Math.random()*32)+'';
      var recordAttrs = {colorId: randomColor};
      recordAttrs[trackableType] = trackable;

      var recordType = `checkin_${trackableType}`.camelize();
      var tracked = this.get('store').createRecord(recordType, recordAttrs);
      this.get('trackeds').pushObject(tracked);

      this.get('addedTrackeds').pushObject(tracked);
    }
    this.set('selectedTrackable', null);
  },

  saveCheckin: function() {
    var trackableType = this.get('trackableType');
    // untrack() all removedTrackeds if isTodaysCheckin
    this.get('removedTrackeds').forEach(record => {
      if (this.get('isTodaysCheckin')) {
        this.get('tracking').untrack({
          trackable: record.get(trackableType)
        });
      }
    });

    // track() all addedTrackeds if isTodaysCheckin
    this.get('addedTrackeds').forEach(record => {
      if (this.get('isTodaysCheckin')) {
        var trackable = record.get(trackableType);
        this.get('tracking').track(trackable, trackable.get('colorId'));
      }
    });

    // we need to delete value on treatments not taken
    if (this.get('trackableTypeIsTreatment')) {
      this.get('trackeds').forEach(record => {
        record.cleanIfUntaken();
      });
    }

    // save checkin
    this.get('checkin').save().then(() => {
      Ember.Logger.debug('Checkin successfully saved');
      // remove the added ones to avoid 'ghost' records
      this.get('addedTrackeds').forEach(record => {
        record.deleteRecord();
      });
    });

  }
});
