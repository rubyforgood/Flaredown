import Ember from 'ember';

const {
  $,
  get,
  computed,
  Component,
  run: { scheduleOnce },
  computed: { alias },
} = Ember;

export default Component.extend({
  classNames: ['checkin-navigation'],

  checkinId: alias('checkin.id'),

  steps: computed('stepsService.steps', function() {
    let result = [];
    const steps = get(this, 'stepsService.steps');

    Object.keys(steps).forEach(key => {
      let step = steps[key];

      if (step.priority && step.prefix === 'checkin') {
        result.pushObject(step);
      }
    });

    return result.sortBy('priority');
  }),

  didRender() {
    scheduleOnce('afterRender', this, () => {
      const $activeLink = $('.checkin-navigation .active');

      if (!$activeLink.length) {
        return;
      }

      const $checkinNavigation = $('.checkin-navigation');
      const offsetedCenter = ($checkinNavigation.width() - $activeLink.width()) / 2;
      const absoluteScrollTo = - (offsetedCenter - $checkinNavigation.scrollLeft() - $activeLink.offset().left);

      $checkinNavigation.animate({ scrollLeft: absoluteScrollTo }, 0);
    });
  },
});
