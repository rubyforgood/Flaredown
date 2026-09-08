import Ember from 'ember';
import moment from 'moment';

const {
  isBlank,
} = Ember;

const CALENDAR_DAY = 'YYYY-MM-DD';

/*
  A check-in's `date` is a calendar day, not an instant.

  The client asks for a check-in by the browser's local day ("2022-01-24", see
  routes/checkin/index.js) and Api::V1::CheckinsController#create stores that day
  stamped with the server's own UTC wall clock, so it comes back looking like
  "2022-01-24T01:00:00.000+00:00". Only the 24th is meaningful - the 01:00 and the
  +00:00 are an artefact of when the server happened to handle the request.

  Reading that string as an instant re-dates the check-in for anyone who is not on
  UTC: in Los Angeles it becomes the 23rd, in Sydney the 25th. `moment.parseZone`
  keeps the wall clock exactly as written, so the day survives the round trip.
*/

// The calendar day a check-in was made for, as 'YYYY-MM-DD', or null when the
// check-in has no usable date yet.
export function checkinCalendarDay(checkinDate) {
  if (isBlank(checkinDate)) { return null; }

  // ISO_8601 covers everything that reaches here - the API's timestamp and the
  // bare 'YYYY-MM-DD' a freshly created record carries until it is saved - and
  // keeps moment off its unreliable fall back to `new Date(string)`.
  const day = moment.parseZone(checkinDate, moment.ISO_8601);

  return day.isValid() ? day.format(CALENDAR_DAY) : null;
}

// Whether a check-in is the one for the user's current calendar day. A check-in
// with no date is never today, so a half-loaded record cannot be mistaken for one.
//
// `now` exists so tests can pin the clock; callers should omit it.
export function isCheckinToday(checkinDate, now = new Date()) {
  const day = checkinCalendarDay(checkinDate);

  return day !== null && day === moment(now).format(CALENDAR_DAY);
}
