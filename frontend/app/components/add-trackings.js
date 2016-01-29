import Ember from 'ember';

export default Ember.Component.extend({

  selectableData: Ember.inject.service(),
  tracking: Ember.inject.service(),

  setupTracking: Ember.on('init', function() {
    this.get('tracking').setAt(new Date());
  }),

  trackableTypeIsCondition: Ember.computed.equal('trackableType', 'Condition'),
  trackableTypeIsSymptom: Ember.computed.equal('trackableType', 'Symptom'),
  trackableTypeIsTreatment: Ember.computed.equal('trackableType', 'Treatment'),

  trackables: Ember.computed('trackableType', function() {
    if (this.get('trackableTypeIsCondition')) {
      return this.get('selectableData.conditions')
    } else if (this.get('trackableTypeIsSymptom')) {
      return this.get('selectableData.symptoms')
    } else if (this.get('trackableTypeIsTreatment')) {
      return this.get('selectableData.treatments')
    }
  }),

  selectPlaceholder: Ember.computed('trackableType', function() {
    return 'Add a '+this.get('trackableType');
  }),

  existingTrackings: Ember.computed.alias('tracking.existingTrackings'),
  newTrackings: Ember.computed.alias('tracking.newTrackings'),

  actions: {
    trackSelected() {
      this.get('tracking').track(this.get('selectedTrackable'), () => {
        this.set('selectedTrackable', null);
      });
    }
  }

});
