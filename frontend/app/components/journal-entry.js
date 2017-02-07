import Ember from 'ember';

const {
  get,
  computed,
  Component,
} = Ember;

export default Component.extend({
  classNames: ["flaredown-white-box"],

  date: computed('checkin.date', function() {
    return moment(get(this, 'checkin.date')).format("MMM D");
  }),

  note: computed('checkin.note', function() {
    return get(this, 'checkin.note') || "No note was taken.";
  }),

  checkinId: computed('checkin.id', function() {
    return get(this, 'checkin.id');
  }),
});
