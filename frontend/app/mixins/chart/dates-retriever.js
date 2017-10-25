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

  startAtWithCache: computed('startAt', function() {
    return moment(get(this, 'startAt')).subtract(get(this, 'daysRadius'), 'days');
  }),

  endAtWithCache: computed('endAt', function() {
    return moment(get(this, 'endAt')).add(get(this, 'daysRadius'), 'days');
  })
})
