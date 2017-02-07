import Ember from 'ember';

const {
  get,
  set,
  Component,
  setProperties,
  run: {
    scheduleOnce,
  },
} = Ember;

export default Component.extend({
  checkins: [],
  loadingCheckins: true,

  didInsertElement() {
    this._super(...arguments);

    scheduleOnce('afterRender', this, () => this.fetchCheckins());
  },

  fetchCheckins() {
    return setProperties(this, {
      checkins: this.peekReverseSortedCheckins(),
      loadingCheckins: false,
    });
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
