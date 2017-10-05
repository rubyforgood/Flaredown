import Ember from 'ember';

const {
  get,
  computed,
  Mixin,
} = Ember;

export default Mixin.create({
  startAt: computed('daysRadius', 'centeredDate', function() {
    const daysRadius = get(this, 'daysRadius');
    const centeredDate = get(this, 'centeredDate');

    if (centeredDate) {
      return moment(centeredDate).subtract(daysRadius, 'days');
    } else {
      return moment().subtract(daysRadius * 2, 'days');
    }
  }),

  endAt: computed('daysRadius', 'centeredDate', function() {
    const centeredDate = get(this, 'centeredDate');

    if (centeredDate) {
      return moment(centeredDate).add(get(this, 'daysRadius'), 'days');
    } else {
      return moment();
    }
  }),

  daysRadius: computed('SVGWidth', function() {
    return Math.ceil(get(this, 'SVGWidth') / (get(this, 'pixelsPerDate') * 2));
  }),

  getStartAt: computed('startAt', function() {
    let startAt = get(this, 'startAt');

    return startAt ? startAt : this.daysAgo(get(this, 'dateRange'));
  }),

  getEndAt: computed('endAt', function() {
    let endAt = get(this, 'endAt');
    return endAt ? endAt : this.daysAfter(get(this, 'dateRange'));
  }),

  startAtWithCache: computed('startAt', function() {
    return moment(get(this, 'startAt')).subtract(get(this, 'daysRadius'), 'days');
  }),

  endAtWithCache: computed('endAt', function() {
    return moment(get(this, 'endAt')).add(get(this, 'daysRadius'), 'days');
  }),

  daysAgo(number) {
    let date = new Date();
    let seconds = date.setDate(date.getDate() - number);

    return new Date(seconds);
  },

  daysAfter(number) {
    let date = new Date();
    let seconds = date.setDate(date.getDate() + number);

    return new Date(seconds);
  },
})
