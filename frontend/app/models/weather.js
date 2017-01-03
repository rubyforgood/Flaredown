import DS from 'ember-data';
import Ember from 'ember';
import FieldsByUnits from 'flaredown/mixins/fields-by-units';

let { Model, attr } = DS;
let { get, computed } = Ember;

export default Model.extend(FieldsByUnits, {
  humidity:         attr('number'),
  icon:             attr('string'),
  precipIntensity:  attr('number'),
  pressure:         attr('number'),
  summary:          attr('string'),
  temperatureMax:   attr('number'),
  temperatureMin:   attr('number'),

  pressureInches: computed('pressure', function() {
    return Math.round((29.92 * get(this, 'pressure')) / 10.1325) / 100;
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

  pressureByUnits(unit) {
    return get(this, this.pressureFieldByUnits(unit));
  },

  temperatureMinByUnits(unit) {
    return get(this, unit === 'c' ? 'temperatureMinCelsius' : 'temperatureMin');
  },

  temperatureMaxByUnits(unit) {
    return get(this, unit === 'c' ? 'temperatureMaxCelsius' : 'temperatureMax');
  },
});
