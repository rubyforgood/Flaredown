import Ember from 'ember';
import TrackablesFromType from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromType, {


  activeTrackables: Ember.computed(''), //fetch them from the checkin object

  actions: {
    trackSelected() {
      this.get('tracking').track(this.get('selectedTrackable'), () => {
        this.set('selectedTrackable', null);
      });
    }
  }

});
