import Ember from 'ember';

const {
  get,
  set,
  computed,
  Component,
  run: { scheduleOnce },
  String: { htmlSafe },
} = Ember;

export default Component.extend({
  symptoms: [],
  classNames: ["flaredown-white-box"],
  symptomAverage: 0,

  date: computed('checkin.date', function() {
    return moment(get(this, 'checkin.date')).format("MMM D");
  }),

  note: computed('checkin.note', function() {
    return get(this, 'checkin.note') || "No note was taken.";
  }),

  style: computed('symptomAverage', function() {
    return htmlSafe(`width: ${get(this, 'symptomAverage') * 100 / 5}%`);
  }),

  checkinId: computed('checkin.id', function() {
    return get(this, 'checkin.id');
  }),

  symptomCeil: computed('symptomAverage', function() {
    return Math.round(get(this, 'symptomAverage'));
  }),

  didInsertElement() {
    this._super(...arguments);

    scheduleOnce('afterRender', this, () => {
      get(this, 'checkin.symptoms').then(symptoms =>
        set(this, 'symptomAverage', symptoms.reduce((acc, s) => acc + get(s, 'value'), 0) / symptoms.length)
      );
    });
  },
});
