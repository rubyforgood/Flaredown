import moment from 'moment-timezone';
import { module, test } from 'qunit';
import { checkinCalendarDay, isCheckinToday } from 'flaredown/utils/checkin-day';

/*
  A check-in's `date` is a calendar day wearing a UTC costume.

  The client asks for a check-in using the browser's local day ("2022-01-24", see
  routes/checkin/index.js) and Api::V1::CheckinsController#create stamps the
  server's UTC wall clock onto it, so the API hands back something like
  "2022-01-24T01:00:00.000+00:00". The 01:00 and the +00:00 carry no meaning; only
  the 24th does.

  These tests pin moment's default zone because the bug is invisible in UTC - which
  is exactly why it survived so long, and why CI (which runs in UTC) would not
  otherwise catch a regression.
*/

module('Unit | Utility | checkin day', {
  afterEach() {
    moment.tz.setDefault(); // back to the runner's real zone
  }
});

test('reads the day as written for an evening check-in behind UTC', function(assert) {
  moment.tz.setDefault('America/Los_Angeles');

  // Checked in at 17:00 on the 24th in Los Angeles, when UTC had already ticked
  // over to 01:00 on the 25th.
  assert.equal(checkinCalendarDay('2022-01-24T01:00:00.000+00:00'), '2022-01-24');
});

test('reads the day as written for a morning check-in ahead of UTC', function(assert) {
  moment.tz.setDefault('Australia/Sydney');

  // Checked in at 10:00 on the 24th in Sydney, when UTC was still 23:00 on the 23rd.
  assert.equal(checkinCalendarDay('2022-01-24T23:00:00.000+00:00'), '2022-01-24');
});

test('leaves the day alone for users already on UTC', function(assert) {
  moment.tz.setDefault('UTC');

  assert.equal(checkinCalendarDay('2022-01-24T01:00:00.000+00:00'), '2022-01-24');
  assert.equal(checkinCalendarDay('2022-01-24T23:00:00.000+00:00'), '2022-01-24');
});

test('reads a bare day, as set on a record that has not reached the server yet', function(assert) {
  moment.tz.setDefault('America/Los_Angeles');

  // mixins/checkin-by-date.js#routeToNewCheckin creates the record with a plain
  // 'YYYY-MM-DD' before the API fills in its own timestamp.
  assert.equal(checkinCalendarDay('2022-01-24'), '2022-01-24');
});

test('has no day to report when the date is missing or unparseable', function(assert) {
  assert.equal(checkinCalendarDay(null), null);
  assert.equal(checkinCalendarDay(undefined), null);
  assert.equal(checkinCalendarDay(''), null);
  assert.equal(checkinCalendarDay('   '), null);
  assert.equal(checkinCalendarDay('not a date'), null);
});

test("an evening check-in behind UTC is still today's check-in", function(assert) {
  moment.tz.setDefault('America/Los_Angeles');

  const now = new Date('2022-01-25T01:00:00.000Z'); // 17:00 on the 24th in Los Angeles

  assert.ok(
    isCheckinToday('2022-01-24T01:00:00.000+00:00', now),
    'a treatment added at 17:00 must still be tracked for future check-ins'
  );
});

test("a morning check-in ahead of UTC is still today's check-in", function(assert) {
  moment.tz.setDefault('Australia/Sydney');

  const now = new Date('2022-01-23T23:00:00.000Z'); // 10:00 on the 24th in Sydney

  assert.ok(
    isCheckinToday('2022-01-24T23:00:00.000+00:00', now),
    'a treatment added at 10:00 must still be tracked for future check-ins'
  );
});

test("a past check-in is not today's check-in", function(assert) {
  moment.tz.setDefault('America/Los_Angeles');

  const now = new Date('2022-01-25T01:00:00.000Z'); // 17:00 on the 24th in Los Angeles

  assert.notOk(
    isCheckinToday('2022-01-23T01:00:00.000+00:00', now),
    'back-filling yesterday must not change what gets tracked going forward'
  );
});

test("a future check-in is not today's check-in", function(assert) {
  moment.tz.setDefault('Australia/Sydney');

  const now = new Date('2022-01-23T23:00:00.000Z'); // 10:00 on the 24th in Sydney

  assert.notOk(isCheckinToday('2022-01-25T23:00:00.000+00:00', now));
});

test('an unknown date is never today', function(assert) {
  const now = new Date('2022-01-25T01:00:00.000Z');

  assert.notOk(isCheckinToday(null, now), 'an unloaded check-in must not be tracked against');
  assert.notOk(isCheckinToday('', now));
  assert.notOk(isCheckinToday('not a date', now));

  // moment(undefined) is *now*, so a half-loaded check-in used to look like
  // today's and could have had trackings created against it.
  assert.notOk(isCheckinToday(undefined));
});

test('falls back to the current time when no clock is supplied', function(assert) {
  moment.tz.setDefault('America/Los_Angeles');

  const todayInLosAngeles = moment().format('YYYY-MM-DD');

  assert.ok(isCheckinToday(`${todayInLosAngeles}T01:00:00.000+00:00`));
  assert.notOk(isCheckinToday(`${todayInLosAngeles}T01:00:00.000+00:00`, new Date('2000-01-01T12:00:00.000Z')));
});
