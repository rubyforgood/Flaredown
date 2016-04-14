import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  // Attributes
  group: DS.attr('string'),
  key: DS.attr('string'),
  title: DS.attr('string'),
  shortTitle: DS.attr('string'),
  hint: DS.attr('string'),
  priority: DS.attr('number'),

  // for internal use only
  prevId: DS.attr('string'),
  nextId: DS.attr('string'),

  //Associations
  prev: DS.belongsTo('step', { inverse: null }),
  next: DS.belongsTo('step', { inverse: null }),

  // Properties
  isFirst: Ember.computed.none('prevId'),
  isLast: Ember.computed.none('nextId'),
  hasPrev: Ember.computed.not('isFirst'),
  hasNext: Ember.computed.not('isLast')
});
