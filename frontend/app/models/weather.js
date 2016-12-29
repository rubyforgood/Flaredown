import DS from 'ember-data';
import Ember from 'ember';

let { Model, attr } = DS;
let { computed } = Ember;

export default Model.extend({
  humidity:         attr('number'),
  icon:             attr('string'),
  precipIntensity:  attr('number'),
  pressure:         attr('number'),
  temperatureMax:   attr('number'),
  temperatureMin:   attr('number'),
});
