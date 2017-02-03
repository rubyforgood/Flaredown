import Ember from 'ember';

const {
  $,
  Component,
  run: { scheduleOnce },
  computed: { alias },
} = Ember;

export default Component.extend({
  classNames: ['checkin-navigation'],

  checkinId: alias('checkin.id'),

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
