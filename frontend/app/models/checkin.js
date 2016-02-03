import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  date: DS.attr('date'),

  checkinConditions: DS.hasMany('checkinCondition'),
  checkinSymptoms: DS.hasMany('checkinSymptom'),
  checkinTreatments: DS.hasMany('checkinTreatment'),

  formattedDate: Ember.computed('date', function() {
    return moment(this.get('date')).format("YYYY-MM-DD");
  }),
});
