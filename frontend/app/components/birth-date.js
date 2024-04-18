import Component from '@ember/component';
import { get, computed } from '@ember/object';
import moment from 'moment';

export default Component.extend({
  classNames: ['birthDate'],

  startYear: 1920,

  months: computed(() => {
    let monthArray = [];

    for(let i = 1; i<= 12; i++) {
      monthArray.push(i.toString());
    }

    return monthArray;
  }),

  yearsArray: computed('birthDate.date', function() {
    let yearsArray = [];
    const endYear = parseInt(moment().subtract(10, 'years').format('YYYY'));
    const startYear = this.get('startYear');

    for (let i=endYear; i>=startYear; i--) {
      yearsArray.push(i.toString());
    }

    return yearsArray;
  }),

  disabledDays: computed('birthDate.{year,month}', function() {
    return !(get(this, 'birthDate.year') && get(this, 'birthDate.month'));
  }),

  daysArray: computed('birthDate.{year,month}', function() {
    let days = [];

    if (!get(this, 'disabledDays')) {
      const year = get(this, 'birthDate.year');
      const month = get(this, 'birthDate.month');

      for (let d = 1; d <= this.daysInMonth(month, year); d ++) {
        days.push(d.toString());
      }
    }

    return days;
  }),

  daysInMonth(month, year) {
    return new Date(year, month, 0).getDate();
  },
});
