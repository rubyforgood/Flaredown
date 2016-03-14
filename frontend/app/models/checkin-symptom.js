import DS from 'ember-data';
import Ember from 'ember';
import CheckinTrackable from 'flaredown/models/checkin-trackable';

export default CheckinTrackable.extend({
  value: DS.attr('number'),

  symptom: DS.belongsTo('symptom'),

  setPropsFromSymptom: Ember.on('init', Ember.observer('symptom', function() {
    this.get('symptom').then(symptom => {
      if (Ember.isPresent(symptom)) {
        this.set('label', symptom.get('name'));
        if (Ember.isBlank(this.get('colorId'))) {
          this.set('colorId', symptom.get('colorId'));
        }
      }
    });
  }))

});
