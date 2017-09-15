import DS from 'ember-data';
import Ember from 'ember';

const {
  attr,
  Model,
  belongsTo,
} = DS;

export default Model.extend({
  score: attr('number'),
  checkin: belongsTo('checkin'),
});
