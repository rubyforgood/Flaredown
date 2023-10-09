import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";
import moment from 'moment-timezone';

const {
  get,
  set,
  computed,
  computed: {
    alias,
  },
  inject: {
    service,
  },
  Component,
} = Ember;

export default Component.extend({
  i18n: service(),

  profile: alias('model'),

  classNames: ['checkinReminder'],

  checkinReminderEnabled: alias('profile.checkinReminder'),

  reminderOff: t("step.onboarding.reminder.reminderOff"),
  reminderOn:  t("step.onboarding.reminder.reminderOn"),
  title: null,

  timezones: computed(function() {
    let originNames = moment.tz.names();

    if(originNames) {
      return originNames.map((timezone) => {
        return timezone.split('_').join(' ');
      })
    } else {
      return [];
    }
  }),

  options: computed(function() {
    return {
      hour: get(this, 'profile.checkinReminderAt.hours'),
      mins: get(this, 'profile.checkinReminderAt.minutes'),
      format: 'hh:i A'
    }
  }),

  actions: {
    changeReminder(boolParam) {
      set(this, 'profile.checkinReminder', boolParam);
    },

    timeChanged(param) {
      let parsedParam = { hours: param.getHours(), minutes: param.getMinutes() };

      set(this, 'profile.checkinReminderAt', parsedParam);
    }
  },
});
