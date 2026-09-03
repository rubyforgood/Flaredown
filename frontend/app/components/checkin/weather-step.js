import Ember from 'ember';

let { Component, computed, computed: { alias, notEmpty }, get, inject: { service }, isBlank, set, setProperties } = Ember;

export default Component.extend({
  store: service(),

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

  newPostalCode: '',
  manuallyOpened: false,
  validPostalCode: true,

  checkin: alias('parentView.model.checkin'),
  hasLocation: notEmpty('checkin.locationName'),
  hasWeather: notEmpty('weather'),
  pressureUnits: alias('session.currentUser.profile.pressureUnits'),
  temperatureUnits: alias('session.currentUser.profile.temperatureUnits'),
  weather: alias('checkin.weather'),

  formattedPrecipitation: computed('weather.precipIntensity', function() {
    return get(this, 'weather.precipIntensity').toString().split('.')[1];
  }),

  shownTemperatureMin: computed('weather.temperatureMin', 'temperatureUnits', function() {
    return get(this, 'weather').temperatureMinByUnits(get(this, 'temperatureUnits'));
  }),

  shownTemperatureMax: computed('weather.temperatureMax', 'temperatureUnits', function() {
    return get(this, 'weather').temperatureMaxByUnits(get(this, 'temperatureUnits'));
  }),

  shownPressure: computed('weather.pressure', 'pressureUnits', function() {
    return get(this, 'weather').pressureByUnits(get(this, 'pressureUnits'));
  }),

  iconType: computed('weather.icon', function() {
    let icon = get(this, 'weather.icon');

    return get(this, 'weatherTypes').includes(icon) ? icon : 'default';
  }),

  // The location lives on the check-in and is carried over to the next one, so we
  // only ask for it while the check-in has none, or while the user is changing it.
  // A day without weather is not a day without a location: the forecast may just
  // not be available for it.
  inputVisible: computed('hasLocation', 'manuallyOpened', function() {
    return get(this, 'manuallyOpened') || !get(this, 'hasLocation');
  }),

  actions: {
    updatePostalCode() {
      const checkin = get(this, 'checkin');
      const newPostalCode = get(this, 'newPostalCode');
      const existingPostalCode = get(checkin, 'postalCode');
      const existingWeather = get(checkin, 'weather');

      if(isBlank(newPostalCode)) {
        set(this, 'validPostalCode', false);

        return;
      }

      return get(this, 'store')
        .queryRecord('weather', { date: get(checkin, 'date'), postal_code: newPostalCode })
        // Weather can be missing for a day (no forecast, API down) without the
        // location being wrong, so save the location either way. If this is only
        // a retry of the saved location, however, a request failure must not
        // erase weather the check-in already has.
        .catch(() => newPostalCode === existingPostalCode ? existingWeather : null)
        .then(record => {
          setProperties(checkin, { postalCode: newPostalCode, weather: record });

          return checkin.save();
        })
        .then(() => {
          // The API only echoes a postal code back once it has geocoded it into a
          // position, so this is what tells us the location itself was understood.
          const accepted = get(checkin, 'postalCode') === newPostalCode;

          setProperties(this, { validPostalCode: accepted, manuallyOpened: !accepted });
        });
    },

    showInput() {
      setProperties(this, {
        manuallyOpened: true,
        validPostalCode: true,
        newPostalCode: get(this, 'checkin.postalCode'),
      });
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

      return profile.save();
    });
  },
});
