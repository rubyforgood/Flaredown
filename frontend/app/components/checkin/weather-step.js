import Ember from 'ember';

let { Component, computed, computed: { alias, notEmpty }, get, set, setProperties } = Ember;

export default Component.extend({
  classNames: ['centered'],
  weatherTypes: [
    'clear-day',
    'clear-night',
    'cloudy',
    'fog',
    'partly-cloudy-day',
    'partly-cloudy-night',
    'rain',
    'sleet',
    'snow',
    'wind',
  ],

  inputVisible: false,

  checkin: alias('parentView.model.checkin'),
  hasWeather: notEmpty('weather'),
  pressureUnits: alias('session.currentUser.profile.pressureUnits'),
  temperatureUnits: alias('session.currentUser.profile.temperatureUnits'),
  weather: alias('checkin.weather'),

  shownTemperatureMin: computed('weather.temperatureMin', 'temperatureUnits', function() {
    return get(this, `weather.${get(this, 'temperatureUnits') === 'c' ? 'temperatureMinCelsius' : 'temperatureMin'}`);
  }),

  shownTemperatureMax: computed('weather.temperatureMax', 'temperatureUnits', function() {
    return get(this, `weather.${get(this, 'temperatureUnits') === 'c' ? 'temperatureMaxCelsius' : 'temperatureMax'}`);
  }),

  shownPressure: computed('weather.pressure', 'pressureUnits', function() {
    return get(this, `weather.${get(this, 'pressureUnits') === 'in' ? 'pressureInches' : 'pressure'}`);
  }),

  iconType: computed('weather.icon', function() {
    let icon = get(this, 'weather.icon');

    return get(this, 'weatherTypes').includes(icon) ? icon : 'default';
  }),

  iconText: computed('weather.icon', function() {
    let text = get(this, 'weather.icon').replace(/-/g, ' ');

    return `${text.charAt(0).toUpperCase()}${text.slice(1)}`;
  }),

  willRender() {
    this._super(...arguments);

    if (!get(this, 'hasWeather')) {
      set(this, 'inputVisible', true);
    }
  },

  actions: {
    updatePostalCode() {
      const date = get(this, 'checkin.date');
      const newPostalCode = get(this, 'newPostalCode');

      this
        .store
        .queryRecord('weather', { date: date, postal_code: newPostalCode })
        .then(record => {
          let checkin = get(this, 'checkin');

          setProperties(checkin, { postalCode: newPostalCode, weather: record });

          return checkin.save();
        })
        .then(() => set(this, 'inputVisible', false));
    },

    showInput() {
      setProperties(this, { inputVisible: true, newPostalCode: get(this, 'checkin.postalCode') });
    },

    toggleTemperatureUnits() {
      this.updateProfileFieldFromMap('temperatureUnits', { c: 'f', f: 'c' });
    },

    togglePressureUnits() {
      this.updateProfileFieldFromMap('pressureUnits', { mb: 'in', in: 'mb' });
    },
  },

  updateProfileFieldFromMap(field, map) {
    get(this, 'session.currentUser.profile').then(profile => {
      set(profile, field, map[get(this, field)]);

      return profile.save()
    });
  },
});
