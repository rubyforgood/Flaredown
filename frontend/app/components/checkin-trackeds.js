import Ember from 'ember';
import TrackablesFromType from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromType, {

  checkinTrackeds: Ember.computed('checkin', function() {
    var key = this.get('trackableType').pluralize();
    return this.get(`checkin.${key}`);
  }),

  actions: {
    remove(tracked) {
      Ember.Logger.debug('remove');
      Ember.Logger.debug(tracked);
      /* TODO:
         1) Remove tracking from checkin
         2) invoke untrack() only if isToday
      */
    },

    checkinSelected() {
      Ember.Logger.debug('checkinSelected');
      /* TODO:
         1) Add tracking to checkin
         2) invoke track() only if isToday
      */
    }
  }

});
