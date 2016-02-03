import Ember from 'ember';
import TrackablesFromType from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromType, {

  checkinTrackables: Ember.computed('checkin', function() {
    if (this.get('trackableTypeIsCondition')) {
      return this.get('checkin.conditions');
    } // TODO else
  }),

  actions: {
    trackSelected() {
      Ember.Logger.debug('trackSelected');
      /* TODO:
         1) Add tracking to checkin
         2) invoke track() only if isToday
      */
    }
  }

});
