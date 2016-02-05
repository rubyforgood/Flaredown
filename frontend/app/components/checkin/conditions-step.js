import Ember from 'ember';

export default Ember.Component.extend({

  tracking: Ember.inject.service(),

  setupTracking: Ember.on('init', function() {
    this.get('tracking').setAt(new Date());  // Trackings in the past don't matter by reqs
  }),

  trackableType: "condition",
  model: Ember.computed.alias('parentView.model'),
  checkin: Ember.computed.alias('model.checkin'),
  isTodaysCheckin: Ember.computed('checkin', function() {
    return moment(this.get('checkin.date')).isSame(new Date(), 'day');
  }),

  actions: {
    completeStep() {
      this.saveCheckin();
      this.get('onStepCompleted')();
    },
    goBack() {
      this.saveCheckin();
      this.get('onGoBack')();
    },
    rememberRemovedTracked(tracked) {
      this.get('removedTrackeds').pushObject(tracked);
    },
    rememberAddedTracked(tracked) {
      this.get('addedTrackeds').pushObject(tracked);
    }
  },

  removedTrackeds: Ember.A([]),
  addedTrackeds: Ember.A([]),

  saveCheckin: function() {
    var trackableType = this.get('trackableType');
    // untrack() all removedTrackeds if isTodaysCheckin
    this.get('removedTrackeds').forEach(record => {
      if (this.get('isTodaysCheckin')) {
        this.get('tracking').untrack(record.get(trackableType));
      }
      record.destroyRecord();
    });

    // track() all addedTrackeds if isTodaysCheckin
    this.get('addedTrackeds').forEach(record => {
      if (this.get('isTodaysCheckin')) {
        var trackable = record.get(trackableType);
        this.get('tracking').track(trackable, trackable.get('colorId'));
      }
    });

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
