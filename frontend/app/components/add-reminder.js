import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

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
    return typeof moment !== 'undefined' && moment.tz && moment.tz.names();
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
