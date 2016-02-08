import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  value: DS.attr('number'),
  symptom: DS.belongsTo('symptom')
});
