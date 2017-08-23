import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

const {
  get,
  set,
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

  actions: {
    changeReminder(boolParam) {
      set(this, 'profile.checkinReminder', boolParam);
    },

    timeChanged(param) {
      set(this, 'profile.checkinReminderAt', param);
    }
  },
});
