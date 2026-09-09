import Ember from 'ember';
import { moduleForComponent, test } from 'ember-qunit';
import { settled } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import WeatherStep from 'flaredown/components/checkin/weather-step';

const { RSVP, get, set, setProperties } = Ember;

const LOCATION_NAME = 'Minneapolis, Minnesota, United States';

// Stands in for the check-in record. `save()` behaves like the API, which only
// echoes a postal code and a location name back once it has managed to geocode
// the postal code into a position.
function checkinStub(attrs) {
  return Ember.Object.create({
    date: '2023-12-05',
    postalCode: null,
    locationName: null,
    weather: null,
    geocodable: true,

    save() {
      if (get(this, 'geocodable')) {
        set(this, 'locationName', LOCATION_NAME);
      } else {
        setProperties(this, { postalCode: null, locationName: null });
      }

      return RSVP.resolve(this);
    },
  }, attrs || {});
}

function weatherStub() {
  return Ember.Object.create({
    icon: 'cloudy',
    summary: 'General conditions are cloudy.',
    humidity: 81,
    precipIntensity: 0.25,
    temperatureMinByUnits() { return 28; },
    temperatureMaxByUnits() { return 33; },
    pressureByUnits() { return 29.28; },
  });
}

function text(context) {
  return context.$().text().trim().replace(/\s+/g, ' ');
}

let weatherQueries;
let weatherResponse;

moduleForComponent('checkin/weather-step', 'Integration | Component | checkin/weather step', {
  integration: true,

  beforeEach() {
    weatherQueries = [];
    weatherResponse = () => RSVP.resolve(null);

    // The check-in wizard passes the check-in down through `parentView.model`.
    // Override that alias so these tests can hand one straight to the component.
    this.register('component:checkin/weather-step', WeatherStep.extend({ checkin: null }));

    this.register('service:store', Ember.Service.extend({
      queryRecord(modelName, query) {
        weatherQueries.push([modelName, query]);

        return weatherResponse();
      }
    }));
  }
});

test('it asks for a location when the check-in has none', function(assert) {
  this.set('checkin', checkinStub());

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);

  assert.equal(
    text(this),
    'Weather To enable weather tracking, enter your location below Submit'
  );
  assert.equal(this.$('input').length, 1, 'the location input is shown');
});

test('it shows the saved location instead of asking again when weather is missing', function(assert) {
  this.set('checkin', checkinStub({ postalCode: '55403', locationName: LOCATION_NAME }));

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);

  assert.equal(this.$('input').length, 0, 'the location input stays hidden');
  assert.equal(
    text(this),
    `Weather ${LOCATION_NAME} Weather data is not available for this day.`
  );
});

test('it shows the weather for a check-in that has some', function(assert) {
  this.set('checkin', checkinStub({
    postalCode: '55403',
    locationName: LOCATION_NAME,
    weather: weatherStub(),
  }));

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);

  assert.equal(this.$('input').length, 0, 'the location input stays hidden');
  assert.equal(this.$('.measurement').length, 5, 'the measurements are shown');
  assert.equal(
    text(this).indexOf('Weather data is not available'),
    -1,
    'no unavailable notice is shown'
  );
});

test('clicking the saved location reopens the input, prefilled', function(assert) {
  this.set('checkin', checkinStub({ postalCode: '55403', locationName: LOCATION_NAME }));

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('.grey.clickable').click();

  assert.equal(this.$('input').val(), '55403', 'the input is prefilled with the postal code');
  assert.ok(text(this).indexOf('Set location:') > -1, 'the copy is about changing the location');
});

test('submitting a blank location reports it as not found', function(assert) {
  this.set('checkin', checkinStub());

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('.save-status').click();

  assert.deepEqual(weatherQueries, [], 'no weather is requested');
  assert.ok(
    text(this).indexOf("We couldn't find that location") > -1,
    'the location is reported as not found'
  );
});

test('submitting a location saves it and hides the input', function(assert) {
  const checkin = checkinStub();

  weatherResponse = () => RSVP.resolve(weatherStub());
  this.set('checkin', checkin);

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('input').val('55403').trigger('input');
  this.$('.save-status').click();

  return settled().then(() => {
    assert.deepEqual(
      weatherQueries,
      [['weather', { date: '2023-12-05', postal_code: '55403' }]],
      'the weather for the check-in date and postal code is requested'
    );
    assert.equal(get(checkin, 'postalCode'), '55403', 'the postal code is saved on the check-in');
    assert.equal(this.$('input').length, 0, 'the location input is hidden');
    assert.equal(this.$('.measurement').length, 5, 'the measurements are shown');
    assert.ok(text(this).indexOf(LOCATION_NAME) > -1, 'the saved location is shown');
  });
});

test('it keeps the location when there is no weather for the day', function(assert) {
  const checkin = checkinStub();

  // The API answers with no weather when it has no forecast for the day.
  weatherResponse = () => RSVP.resolve(null);
  this.set('checkin', checkin);

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('input').val('55403').trigger('input');
  this.$('.save-status').click();

  return settled().then(() => {
    assert.equal(get(checkin, 'postalCode'), '55403', 'the postal code is still saved');
    assert.equal(this.$('input').length, 0, 'the location input is hidden');
    assert.equal(
      text(this),
      `Weather ${LOCATION_NAME} Weather data is not available for this day.`
    );
  });
});

test('it keeps the location when the weather request fails', function(assert) {
  const checkin = checkinStub();

  weatherResponse = () => RSVP.reject(new Error('500 from the weather endpoint'));
  this.set('checkin', checkin);

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('input').val('55403').trigger('input');
  this.$('.save-status').click();

  return settled().then(() => {
    assert.equal(get(checkin, 'postalCode'), '55403', 'the postal code is still saved');
    assert.equal(this.$('input').length, 0, 'the location input is hidden');
  });
});

test('retrying the saved location does not erase weather when the request fails', function(assert) {
  const existingWeather = weatherStub();
  const checkin = checkinStub({
    postalCode: '55403',
    locationName: LOCATION_NAME,
    weather: existingWeather,
  });

  weatherResponse = () => RSVP.reject(new Error('500 from the weather endpoint'));
  this.set('checkin', checkin);

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('.grey.clickable').click();
  this.$('.save-status').click();

  return settled().then(() => {
    assert.equal(get(checkin, 'weather'), existingWeather, 'the existing weather is preserved');
    assert.equal(this.$('.measurement').length, 5, 'the existing measurements remain visible');
  });
});

test('retrying the saved location does not erase weather when no weather is returned', function(assert) {
  const existingWeather = weatherStub();
  const checkin = checkinStub({
    postalCode: '55403',
    locationName: LOCATION_NAME,
    weather: existingWeather,
  });

  weatherResponse = () => RSVP.resolve(null);
  this.set('checkin', checkin);

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('.grey.clickable').click();
  this.$('.save-status').click();

  return settled().then(() => {
    assert.equal(get(checkin, 'weather'), existingWeather, 'the existing weather is preserved');
    assert.equal(this.$('.measurement').length, 5, 'the existing measurements remain visible');
  });
});

test('changing location clears weather from the old location when the request fails', function(assert) {
  const checkin = checkinStub({
    postalCode: '55403',
    locationName: LOCATION_NAME,
    weather: weatherStub(),
  });

  weatherResponse = () => RSVP.reject(new Error('500 from the weather endpoint'));
  this.set('checkin', checkin);

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('.grey.clickable').click();
  this.$('input').val('10001').trigger('input');
  this.$('.save-status').click();

  return settled().then(() => {
    assert.equal(get(checkin, 'postalCode'), '10001', 'the new location is saved');
    assert.equal(get(checkin, 'weather'), null, 'weather from the old location is cleared');
  });
});

test('a location the API cannot geocode is reported as not found', function(assert) {
  const checkin = checkinStub({ geocodable: false });

  this.set('checkin', checkin);

  this.render(hbs`{{checkin/weather-step checkin=checkin}}`);
  this.$('input').val('nowhere').trigger('input');
  this.$('.save-status').click();

  return settled().then(() => {
    assert.equal(this.$('input').length, 1, 'the location input stays open');
    assert.ok(
      text(this).indexOf("We couldn't find that location") > -1,
      'the location is reported as not found'
    );
  });
});
