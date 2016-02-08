import Ember from 'ember';
import TrackablesFromType from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromType, {

  store: Ember.inject.service(),

  actions: {
    remove(tracked) {
      tracked.prepareForDestroy();
      this.get('onTrackedRemoved')(tracked);
    },

    add() {
      var selectedTrackable = this.get('selectedTrackable');
      var trackableType = this.get('trackableType');
      // check if selectedTrackable is already present in this checkin
      var trackable = this.get('trackeds').findBy(`${trackableType}.id`, selectedTrackable.get('id'));
      if (Ember.isNone(trackable)) {
        var randomColor = Math.floor(Math.random()*32)+'';
        var recordAttrs = {colorId: randomColor};
        recordAttrs[trackableType] = selectedTrackable;

        var recordType = `checkin_${trackableType}`.camelize();
        var tracked = this.get('store').createRecord(recordType, recordAttrs);
        this.get('trackeds').pushObject(tracked);

        this.set('selectedTrackable', null);
        this.get('onTrackedAdded')(tracked);
      }
    }
  }

});
