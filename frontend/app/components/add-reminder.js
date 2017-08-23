import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

const {
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

  classNames: ['checkinReminder'],

  reminderOff: t("step.onboarding.reminder.reminderOff"),
  reminderOn:  t("step.onboarding.reminder.reminderOn"),

  checkinReminder: alias('model.profile.checkinReminder'),

  actions: {
    reminderChanged(boolParam) {
      set(this, 'checkinReminder', boolParam);
    },
  }
});
