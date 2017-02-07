import Ember from 'ember';

const {
  get,
  set,
  Component,
  run: {
    scheduleOnce,
  },
} = Ember;

export default Component.extend({
  checkins: [],

  didInsertElement() {
    this._super(...arguments);

    scheduleOnce('afterRender', this, () => this.fetchCheckins());
  },

  fetchCheckins() {
    return set(this, 'checkins', this.peekReverseSortedCheckins());
  },

  peekReverseSortedCheckins() {
    return this
      .store
      .peekAll('checkin')
      .toArray()
      .sort(
        (b, a) => moment(get(a, 'date')).diff(get(b, 'date'), 'days')
      );
  },
});
