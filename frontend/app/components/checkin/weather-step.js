import Ember from 'ember';

let { Component, computed } = Ember;

export default Component.extend({
  classNames: ['centered'],

  checkin: computed.alias('parentView.model.checkin'),
  weather: computed.alias('checkin.weather'),
  hasWeather: computed.notEmpty('weather'),

  inputVisible: false,

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
