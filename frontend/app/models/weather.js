import DS from 'ember-data';

export default DS.Model.extend({
  humidity: DS.attr('number'),
  icon: DS.attr('string'),
  precipIntensity: DS.attr('number'),
  pressure: DS.attr('number'),
  temperatureMax: DS.attr('number'),
  temperatureMin: DS.attr('number'),
});
