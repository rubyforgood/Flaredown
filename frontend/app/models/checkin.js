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
      this.set('tagsChanged', true);
    }
  },
  removeTag: function(tag) {
    this.get('tags').removeObject(tag);
    this.get('tagIds').removeObject(parseInt(tag.get('id')));
    this.set('tagsChanged', true);
  }

});
