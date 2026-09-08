import Ember from 'ember';
import moment from 'moment-timezone';
import { moduleForComponent, test } from 'ember-qunit';

/*
  Adding a treatment to today's check-in has two halves: the treatment is written
  onto the check-in itself, and a Tracking is created so Checkin::Creator seeds it
  into every check-in from then on. Only the second half is gated on
  `isTodaysCheckin`, so when that answers `false` the treatment silently stops
  following the user forward - which is what the two support reports describe.
*/

let trackingSetupOptions;

moduleForComponent('checkin/trackables-step', 'Unit | Component | checkin/trackables-step', {
  unit: true,

  beforeEach() {
    trackingSetupOptions = null;

    this.register('service:tracking', Ember.Service.extend({
      setup(options) { trackingSetupOptions = options; }
    }));
    this.register('service:selectableData', Ember.Service.extend());
  },

  afterEach() {
    moment.tz.setDefault(); // back to the runner's real zone
  }
});

function componentWithCheckinDate(context, date) {
  return context.subject({
    trackableType: 'treatment',
    parentView: { model: { checkin: { date } } }
  });
}

// The API stamps the server's UTC wall clock onto the day the user picked, so an
// evening check-in in Los Angeles comes back carrying a UTC time that belongs to
// the following day. See utils/checkin-day.
function apiDateFor(day, utcClock) {
  return `${day}T${utcClock}.000+00:00`;
}

test('an evening check-in behind UTC is recognised as today', function(assert) {
  moment.tz.setDefault('America/Los_Angeles');

  const component = componentWithCheckinDate(
    this,
    apiDateFor(moment().format('YYYY-MM-DD'), '01:00:00')
  );

  assert.ok(
    component.get('isTodaysCheckin'),
    'treatments added after 16:00 in Los Angeles must still be tracked'
  );
});

test('a morning check-in ahead of UTC is recognised as today', function(assert) {
  moment.tz.setDefault('Australia/Sydney');

  const component = componentWithCheckinDate(
    this,
    apiDateFor(moment().format('YYYY-MM-DD'), '23:00:00')
  );

  assert.ok(
    component.get('isTodaysCheckin'),
    'treatments added before 11:00 in Sydney must still be tracked'
  );
});

test('a check-in from another day is not recognised as today', function(assert) {
  const component = componentWithCheckinDate(this, apiDateFor('2016-01-06', '03:04:05'));

  assert.notOk(
    component.get('isTodaysCheckin'),
    'back-filling an old check-in must not change what gets tracked going forward'
  );
});

test('a check-in with no date yet is not recognised as today', function(assert) {
  const component = componentWithCheckinDate(this, null);

  assert.notOk(component.get('isTodaysCheckin'));
});

test('looks trackings up against the same clock the server stamps them with', function(assert) {
  // TrackingsController#create sets `start_at` from the server's own clock, so the
  // window we search for existing trackings has to be anchored to now too. Anchoring
  // it to the check-in's stored date puts it a day out for anyone off UTC, and
  // `untrack` then cannot find the tracking it is supposed to remove.
  const before = Date.now();
  const component = componentWithCheckinDate(this, apiDateFor('2016-01-06', '03:04:05'));

  component.setupTracking();

  const at = trackingSetupOptions.at;

  assert.ok(at instanceof Date, 'passes a Date');
  assert.ok(
    at.getTime() >= before && at.getTime() <= Date.now(),
    'asks for the trackings active now, not the ones active at the check-in date'
  );
  assert.equal(trackingSetupOptions.trackableType, 'Treatment');
});
