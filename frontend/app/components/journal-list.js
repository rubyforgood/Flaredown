import Ember from 'ember';

const {
  get,
  set,
  computed,
  Component,
  isPresent,
  setProperties,
  run: {
    scheduleOnce,
  },
} = Ember;

export default Component.extend({
  checkins: [],
  loadingCheckins: true,

  page: computed('checkins.[]', function() {
    return Math.floor(get(this, 'checkins.length') / 10) + 1;
  }),

  didInsertElement() {
    this._super(...arguments);

    scheduleOnce('afterRender', this, () => {
      if (this.peekReverseSortedCheckins().length >= 10) {
        this.loadCheckins();
      } else {
        this.fetchMore().then(() => this.loadCheckins());
      }
    });
  },

  fetchMore() {
    return this.store.query('checkin', { page: get(this, 'page') });
  },

  loadCheckins() {
    const checkins = this.peekReverseSortedCheckins();

    if (isPresent(checkins)) {
      setProperties(this, {
        checkins,
        loadingCheckins: false,
      });
    } else {
      setProperties(this, {
        loadingCheckins: false,
        noCheckinsPresent: true,
      });
    }
  },

  peekReverseSortedCheckins() {
    return this
      .store
      .peekAll('checkin')
      .toArray()
      .filter(
        c => isPresent(get(c, 'note'))
      )
      .sort(
        (b, a) => moment(get(a, 'date')).diff(get(b, 'date'), 'days')
      );
  },

  actions: {
    crossedTheLine(above) {
      if (above) {
        set(this, 'loadingCheckins', true);

        this.fetchMore().then(() => this.loadCheckins());
      }
    },
  },
});
