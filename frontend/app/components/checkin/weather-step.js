import Ember from 'ember';

let { Component, computed } = Ember;

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

  checkin: computed.alias('parentView.model.checkin'),
  weather: computed.alias('checkin.weather'),
  hasWeather: computed.notEmpty('weather'),

  iconType: computed('weather.icon', function() {
    let icon = this.get('weather.icon');

    return this.get('weatherTypes').includes(icon) ? icon : 'default';
  }),

  iconText: computed('weather.icon', function() {
    let text = this.get('weather.icon').replace(/-/g, ' ');

    return `${text.charAt(0).toUpperCase()}${text.slice(1)}`;
  }),

  willRender() {
    this._super(...arguments);

    if (!this.get('hasWeather')) {
      this.set('inputVisible', true);
    }
  },

  actions: {
    updatePostalCode() {
      const date = this.get('checkin.date');
      const newPostalCode = this.get('newPostalCode');

      this
        .store
        .queryRecord('weather', { date: date, postal_code: newPostalCode })
        .then(record => {
          let checkin = this.get('checkin');

          checkin.setProperties({ postalCode: newPostalCode, weather: record });

          return checkin.save();
        })
        .then(() => this.set('inputVisible', false));
    },

    showInput() {
      this.setProperties({ inputVisible: true, newPostalCode: this.get('checkin.postalCode') });
    },
  },
});
