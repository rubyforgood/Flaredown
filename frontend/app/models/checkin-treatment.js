import DS from 'ember-data';
import Ember from 'ember';
import CheckinTrackable from 'flaredown/models/checkin-trackable';

export default CheckinTrackable.extend({
  isTaken: DS.attr('boolean'),

  treatment: DS.belongsTo('treatment'),
  dose: DS.belongsTo('dose', { async: false }),

  setPropsFromTreatment: Ember.on('init', Ember.observer('treatment', function() {
    this.get('treatment').then(treatment => {
      if (Ember.isPresent(treatment)) {
        this.set('label', treatment.get('name'));
        if (Ember.isBlank(this.get('colorId'))) {
          this.set('colorId', treatment.get('colorId'));
        }
      }
    });
  }))

});
