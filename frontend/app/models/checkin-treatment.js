import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  value: DS.attr('string'),
  treatment: DS.belongsTo('treatment'),
  name: Ember.computed.alias('condition.name')
});
