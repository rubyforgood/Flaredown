import Ember from 'ember';

export default Ember.Mixin.create({

  selectableData: Ember.inject.service(),

  trackableTypeIsCondition: Ember.computed.equal('trackableType', 'condition'),
  trackableTypeIsSymptom: Ember.computed.equal('trackableType', 'symptom'),
  trackableTypeIsTreatment: Ember.computed.equal('trackableType', 'treatment'),

  trackables: Ember.computed('trackableType', function() {
    var key = this.get('trackableType').pluralize();
    return this.get(`selectableData.${key}`);
  }),

  selectPlaceholder: Ember.computed('trackableType', function() {
    return 'Start typing a '+this.get('trackableType');
  })

});