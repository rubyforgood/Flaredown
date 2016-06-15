import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  date: DS.attr('string'),  // please keep this as string as we don't need timezone info
  note: DS.attr('string'),
  tagIds: DS.attr(),

  conditions: DS.hasMany('checkinCondition'),
  symptoms: DS.hasMany('checkinSymptom'),
  treatments: DS.hasMany('checkinTreatment'),
  tags: DS.hasMany('tag'),

  formattedDate: Ember.computed('date', function() {
    return moment(this.get('date')).format("YYYY-MM-DD");
  }),

  tagsChanged: false,
  addTag: function(tag) {
    var tagId = parseInt(tag.get('id'));
    if (this.get('tagIds').contains(tagId)) {
      return;
    } else {
      this.get('tags').pushObject(tag);
      this.get('tagIds').pushObject(tagId);
      this.set('hasDirtyAttributes', true);
    }
  },
  removeTag: function(tag) {
    this.get('tags').removeObject(tag);
    this.get('tagIds').removeObject(parseInt(tag.get('id')));
    this.set('hasDirtyAttributes', true);
  },

  deleteTrackablesPreparedForDestroy() {
    ['conditions', 'symptoms', 'treatments'].forEach( trackables => {
      this.get(`${trackables}`).toArray().forEach( trackable => {
        if (trackable.get('isPreparedForDestroy')) {
          this.get(trackables).removeObject(trackable);
          trackable.deleteRecord();
        }
      });
    });
  },

  handleSaveError(error) {
    this.get('errors')._add(
      'saveFailure',
      ['Checkin save failed!<br>Please check your connection and then refresh the page.']
    );
    Ember.Logger.error(error);
  },

  isBlank: Ember.computed.and('conditionsBlank', 'symptomsBlank', 'treatmentsBlank', 'tagsBlank', 'noteBlank'),

  conditionsBlank: Ember.computed('conditions', 'conditions.[]', function() {
    return this.get('conditions').toArray().filter(function(condition) {
      return Ember.isPresent(condition.get('value'));
    }).length === 0;
  }),

  symptomsBlank: Ember.computed('symptoms', 'symptoms.[]', function() {
    return this.get('symptoms').toArray().filter(function(symptom) {
      return Ember.isPresent(symptom.get('value'));
    }).length === 0;
  }),

  treatmentsBlank: Ember.computed('treatments', 'treatments.[]', function() {
    return this.get('treatments').toArray().filter(function(treatment) {
      return treatment.get('isTaken');
    }).length === 0;
  }),

  tagsBlank: Ember.computed('tags', 'tags.[]', function() {
    return this.get('tags').toArray().length === 0;
  }),

  noteBlank: Ember.computed('note', function() {
    return Ember.isBlank(this.get('note'));
  }),

  allColorIds: Ember.computed('conditions', 'symptoms', 'treatments', function() {
    let result = Ember.A();
    result.pushObjects(this.get('conditions').mapBy('colorId'));
    result.pushObjects(this.get('symptoms').mapBy('colorId'));
    result.pushObjects(this.get('treatments').mapBy('colorId'));
    return result;
  })

});
