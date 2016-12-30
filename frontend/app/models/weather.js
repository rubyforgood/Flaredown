import DS from 'ember-data';
import Ember from 'ember';

let { Model, attr } = DS;
let { get, computed } = Ember;

export default Model.extend({
  humidity:         attr('number'),
  icon:             attr('string'),
  precipIntensity:  attr('number'),
  pressure:         attr('number'),
  temperatureMax:   attr('number'),
  temperatureMin:   attr('number'),

  pressureInches: computed('pressure', function() {
    return Math.round((29.92 * get(this, 'pressure')) / 1013.25);
  }),

  temperatureMaxCelsius: computed('temperatureMax', function() {
    return this.fahrenheitToCelsius(get(this, 'temperatureMax'));
  }),

  temperatureMinCelsius: computed('temperatureMin', function() {
    return this.fahrenheitToCelsius(get(this, 'temperatureMin'));
  }),

  fahrenheitToCelsius(temp) {
    return Math.round((temp - 32) * 100 / 180);
  },
});
